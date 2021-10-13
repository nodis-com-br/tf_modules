### Identity ##########################

resource "azuread_application" "this" {
  display_name = local.cluster_name
}

resource "azuread_service_principal" "this" {
  application_id = azuread_application.this.application_id
}

resource "azuread_service_principal_password" "this" {
  service_principal_id = azuread_service_principal.this.id
  end_date = timeadd(timestamp(), "87600h")
  lifecycle {
    ignore_changes = [end_date]
  }
}

resource "azurerm_role_assignment" "vnet" {
  scope = var.vnet.id
  role_definition_name = "Reader"
  principal_id = azuread_service_principal.this.object_id
}

resource "azurerm_role_assignment" "subnet" {
  scope = var.subnet.id
  role_definition_name = "Network Contributor"
  principal_id = azuread_service_principal.this.object_id
}


### Cluster ###########################

resource "azurerm_kubernetes_cluster" "this" {
  name = local.cluster_name
  location = var.rg.location
  resource_group_name = var.rg.name
  dns_prefix = local.cluster_name
  kubernetes_version = var.kubernetes_version
  private_cluster_enabled = var.private_cluster_enabled

  service_principal {
    client_id = azuread_service_principal.this.application_id
    client_secret = azuread_service_principal_password.this.value
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
    azuread_service_principal_password.this
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
  orchestrator_version = var.kubernetes_version
  lifecycle {
    ignore_changes = [
      node_labels
    ]
  }
}

# Tunnelfront patch

resource "null_resource" "tunnelfront-patch" {
  triggers = {
    endpoint = azurerm_kubernetes_cluster.this.kube_config.0.host
    ca_crt = azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate
    token = azurerm_kubernetes_cluster.this.kube_config.0.password
  }
  provisioner "local-exec" {
    command = <<EOF
    echo "${base64decode(azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)}" > /tmp/${var.rg.name}-${var.name}.crt
    kubectl \
      --server="${azurerm_kubernetes_cluster.this.kube_config.0.host}" \
      --certificate-authority=/tmp/${var.rg.name}-${var.name}.crt \
      --token="${azurerm_kubernetes_cluster.this.kube_config.0.password}" \
      --namespace kube-system \
      patch deployment tunnelfront \
      --patch='${data.local_file.tunnelfront-patch.content}'
    rm -rf /tmp/${var.rg.name}-${var.name}.crt
    EOF
  }
  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.this
  ]
}


### Networking ########################

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = var.private_dns_linked_vnets
  name = each.key
  private_dns_zone_name = regex("\\.(.*)?", azurerm_kubernetes_cluster.this.private_fqdn).0
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
  virtual_network_id = each.value.id
}
