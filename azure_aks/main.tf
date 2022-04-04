module "service_principal" {
  source = "../azure_service_principal"
  name = local.cluster_name
  homepage_url = "https://${local.cluster_name}"
  create_password = true
  roles = {
    vnet = {
      definition_name = "Reader"
      scope = var.vnet.id
    }
    subnet = {
      definition_name = "Network Contributor"
      scope = var.subnet.id
    }
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name = local.cluster_name
  location = var.rg.location
  resource_group_name = var.rg.name
  dns_prefix = local.cluster_name
  kubernetes_version = var.kubernetes_version
  private_cluster_enabled = var.private_cluster_enabled
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
  role_based_access_control_enabled = var.role_based_access_control_enabled
  service_principal {
    client_id = module.service_principal.application.application_id
    client_secret = module.service_principal.password.value
  }
  network_profile {
    network_plugin = "kubenet"
    pod_cidr = "172.25.0.0/16"
    service_cidr = "172.16.0.0/16"
    dns_service_ip = "172.16.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }
  default_node_pool {
    name = var.default_node_pool_name
    enable_auto_scaling = var.default_node_pool_enable_auto_scaling
    node_count = var.default_node_pool_node_count
    min_count = local.default_node_pool_min_count
    max_count = local.default_node_pool_max_count
    vm_size = var.default_pool_node_size
    vnet_subnet_id = var.subnet.id
    orchestrator_version = var.kubernetes_version
    node_labels = {
      nodePoolName = var.default_node_pool_name
      nodePoolClass = var.default_node_pool_class == null ? var.default_node_pool_name : var.default_node_pool_class
    }
  }
  linux_profile {
    admin_username = var.node_admin_username
    ssh_key {
      key_data = var.node_admin_ssh_key
    }
  }
  depends_on = [
    module.service_principal.password
  ]
  lifecycle {
    ignore_changes = [
      network_profile,
      default_node_pool,
      private_cluster_enabled
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = var.node_pools
  name = each.key
  node_labels = {
    nodePoolName = each.key
    nodePoolClass = each.value.class
  }
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size = try(each.value.vm_size, var.default_pool_node_size)
  enable_auto_scaling = true
  max_count = each.value.max_count
  min_count = each.value.min_count
  vnet_subnet_id = var.subnet.id
  orchestrator_version = try(each.value.kubernetes_version, null)
  lifecycle {
    ignore_changes = [
      node_labels
    ]
  }
}

### Networking ########################

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = var.private_dns_linked_vnets
  name = each.key
  private_dns_zone_name = regex("\\.(.*)?", azurerm_kubernetes_cluster.this.private_fqdn).0
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
  virtual_network_id = each.value.id
}


### Vault #############################

module "vault_auth_backend" {
  source = "../vault_k8s_auth"
  count = var.vault_auth_backend ? 1 : 0
  path = local.cluster_name
  host = local.credentials.host
  ca_certificate = local.credentials.cluster_ca_certificate
  token = data.kubernetes_secret.vault-injector-token.0.data.token
}

module "vault_secrets_backend" {
  source = "../vault_k8s_secrets"
  count = var.vault_secrets_backend ? 1 : 0
  path = "${var.vault_secrets_backend_path}${local.cluster_name}"
  host = local.credentials.host
  ca_cert = local.credentials.cluster_ca_certificate
  jwt = azurerm_kubernetes_cluster.this.kube_config.0.password
 }


## Custom resource definitions ########

resource "null_resource" "crd" {
  for_each = toset(var.custom_resource_definitions)
  triggers = {
    endpoint = azurerm_kubernetes_cluster.this.name
  }
  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.this
  ]
  provisioner "local-exec" {
    command = <<-EOF
    echo "${base64decode(azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)}" > /tmp/${var.rg.name}-${var.name}.crt
    kubectl \
      --server="${azurerm_kubernetes_cluster.this.kube_config.0.host}" \
      --certificate-authority=/tmp/${var.rg.name}-${var.name}.crt \
      --token="${azurerm_kubernetes_cluster.this.kube_config.0.password}" \
      apply -f ${each.key}
    rm -rf /tmp/${var.rg.name}-${var.name}.crt
    EOF
  }

}