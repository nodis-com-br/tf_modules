locals {
  cluster_name = "${var.rg.name}-${var.name}"
  all_pools = [for k, v in var.node_pools : merge(v, {name = k})]
  default_node_pool = local.all_pools[0]
  node_pools = length(local.all_pools) > 1 ? {for p in slice(local.all_pools, 1, length(local.all_pools)) : p.name => p} : {}
}