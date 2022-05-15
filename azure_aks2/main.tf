module "service_principal" {
  source = "../azure_service_principal"
  name = local.cluster_name
  homepage_url = "https://${var.name}.${var.rg.name}"
  create_password = true
  roles = merge(
    var.vnet_id != null ? {vnet = {definition_name = "Reader", scope = var.vnet_id}} : {},
    {for pool in local.node_pools : pool.name => {definition_name = "Network Contributor", scope = pool.vnet_subnet_id} if pool.vnet_subnet_id != null}
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
    name = local.node_pools[0].name
    enable_auto_scaling = local.node_pools[0].enable_auto_scaling
    node_count = local.node_pools[0].node_count
    min_count = local.node_pools[0].min_count
    max_count = local.node_pools[0].max_count
    vm_size = local.node_pools[0].vm_size
    vnet_subnet_id = local.node_pools[0].vnet_subnet_id
    orchestrator_version = local.node_pools[0].orchestrator_version
    node_labels = {
      nodePoolName = local.node_pools[0].name
      nodePoolClass = local.node_pools[0].class
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
  for_each = length(local.node_pools) > 1 ? {for p in slice(local.node_pools, 1, length(local.node_pools)) : p.name => p} : {}
  name = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vnet_subnet_id = each.value.vnet_subnet_id
  enable_auto_scaling = each.value.enable_auto_scaling
  node_count = each.value.node_count
  min_count = each.value.min_count
  max_count = each.value.max_count
  vm_size = each.value.vm_size
  orchestrator_version = each.value.orchestrator_version
  node_labels = {
    nodePoolName = each.value.name
    nodePoolClass = each.value.class
  }
}