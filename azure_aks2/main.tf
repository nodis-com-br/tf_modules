module "service_principal" {
  source = "../azure_service_principal"
  name = local.cluster_name
  homepage_url = "https://${var.name}.${var.rg.name}"
  create_password = true
  roles = merge(
    var.vnet_id != null ? {vnet = {definition_name = "Reader", scope = var.vnet_id}} : {},
    {for id in local.subnet_ids : id => {definition_name = "Network Contributor", scope = id}}
  )
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
    client_secret = module.service_principal.password
  }
  network_profile {
    outbound_type = var.network_outbound_type
    network_plugin = var.network_plugin
    pod_cidr = var.pod_cidr
    service_cidr = var.service_cidr
    dns_service_ip = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
  }
  linux_profile {
    admin_username = var.node_admin_username
    ssh_key {
      key_data = var.node_admin_ssh_key
    }
  }
  default_node_pool {
    name = local.node_pools[local.default_pool_index].name
    enable_auto_scaling = local.node_pools[local.default_pool_index].enable_auto_scaling
    node_count = local.node_pools[local.default_pool_index].node_count
    min_count = local.node_pools[local.default_pool_index].enable_auto_scaling ? local.node_pools[local.default_pool_index].min_count : null
    max_count = local.node_pools[local.default_pool_index].enable_auto_scaling ? local.node_pools[local.default_pool_index].max_count : null
    vm_size = local.node_pools[local.default_pool_index].vm_size
    vnet_subnet_id = local.node_pools[local.default_pool_index].vnet_subnet_id
    orchestrator_version = local.node_pools[local.default_pool_index].orchestrator_version
    node_labels = {
      nodePoolName = local.node_pools[local.default_pool_index].name
      nodePoolClass = local.node_pools[local.default_pool_index].class
    }
    dynamic "linux_os_config" {
      for_each =  local.node_pools[local.default_pool_index].linux_os_config
      content {
        dynamic "sysctl_config" {
          for_each = try(linux_os_config.value.sysctl_config, {})
          content {
            vm_max_map_count = try(sysctl_config.value.vm_max_map_count, null)
          }
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [
      network_profile
    ]
  }
  depends_on = [
    module.service_principal
  ]
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = {for i, v in local.node_pools : v.name => v if i != local.default_pool_index}
  name = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vnet_subnet_id = each.value.vnet_subnet_id
  enable_auto_scaling = each.value.enable_auto_scaling
  node_count = each.value.node_count
  min_count = each.value.enable_auto_scaling ? each.value.min_count : null
  max_count = each.value.enable_auto_scaling ? each.value.max_count : null
  vm_size = each.value.vm_size
  orchestrator_version = each.value.orchestrator_version
  node_labels = {
    nodePoolName = each.value.name
    nodePoolClass = each.value.class
  }
  dynamic "linux_os_config" {
    for_each =  each.value.linux_os_config
    content {
      dynamic "sysctl_config" {
        for_each = try(linux_os_config.value.sysctl_config, [])
        content {
          vm_max_map_count = try(sysctl_config.value.vm_max_map_count, null)
        }
      }
    }
  }
}