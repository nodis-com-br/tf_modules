locals {
  cluster_name = "${var.rg.name}-${var.name}"
  node_pools = [for k, v in var.node_pools : {
    name = k
    default = try(v["default"], length(var.node_pools) == 1 ? true : false)
    enable_auto_scaling = try(v["enable_auto_scaling"], var.default_node_pool_enable_auto_scaling)
    node_count = try(v["node_count"], var.default_node_pool_node_count)
    min_count = try(v["min_count"], var.default_node_pool_min_count)
    max_count = try(v["max_count"], var.default_node_pool_max_count)
    vm_size = try(v["vm_size"], var.default_node_pool_vm_size)
    vnet_subnet_id = try(v["subnet_id"], var.default_node_pool_subnet_id)
    orchestrator_version = try(v["orchestrator_version"], var.kubernetes_version)
    class = try(v["class"], var.default_node_pool_class)
    linux_os_config = try(v["linux_os_config"], [])
  }]
  subnet_ids = distinct([for pool in local.node_pools : pool["vnet_subnet_id"]])
  default_pool_index = index(local.node_pools.*.default, true)
}