module "service_principal" {
  source = "../azure_service_principal"
  name = local.cluster_name
  homepage_url = "https://${var.name}.${var.rg.name}"
  create_password = true
  roles = {
    vnet = {
      definition_name = "Reader"
      scope = var.vnet.id
    }
    subnet = {
      definition_name = "Network Contributor"
      scope = var.default_node_pool_subnet.id
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
  linux_profile {
    admin_username = var.node_admin_username
    ssh_key {
      key_data = var.node_admin_ssh_key
    }
  }
  default_node_pool {
    name = try(local.default_node_pool.name, var.default_node_pool_name)
    enable_auto_scaling = try(local.default_node_pool.enable_auto_scaling, var.default_node_pool_enable_auto_scaling)
    node_count = try(local.default_node_pool.node_count, var.default_node_pool_node_count)
    min_count = try(local.default_node_pool.min_count, var.default_node_pool_min_count)
    max_count = try(local.default_node_pool.max_count, var.default_node_pool_max_count)
    vm_size = try(local.default_node_pool.vm_size, var.default_node_pool_vm_size)
    vnet_subnet_id = try(local.default_node_pool.subnet.id, var.default_node_pool_subnet.id)
    orchestrator_version = try(local.default_node_pool.orchestrator_version, var.kubernetes_version)
    node_labels = {
      nodePoolName = try(local.default_node_pool.name, var.default_node_pool_name)
      nodePoolClass = try(local.default_node_pool.class, var.default_node_pool_class)
    }
  }
  lifecycle {
    ignore_changes = [
      network_profile,
      default_node_pool,
    ]
  }
  depends_on = [
    module.service_principal
  ]

}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = local.node_pools
  name = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vnet_subnet_id = try(each.value.subnet.id)
  enable_auto_scaling = try(each.value.enable_auto_scaling, var.default_node_pool_enable_auto_scaling)
  node_count = try(each.value.node_count, var.default_node_pool_node_count)
  min_count = try(each.value.min_count, var.default_node_pool_min_count)
  max_count = try(each.value.max_count, var.default_node_pool_max_count)
  vm_size = try(each.value.vm_size, var.default_node_pool_vm_size)
  orchestrator_version = try(each.value.orchestrator_version, var.kubernetes_version)
  node_labels = {
    nodePoolName = each.key
    nodePoolClass = try(local.default_node_pool.class, var.default_node_pool_class)
  }
}