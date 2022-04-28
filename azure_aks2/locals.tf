locals {
  cluster_name = "${var.rg.name}-${var.name}"
  all_pools = [for k, v in var.node_pools : merge(v, {name = k})]
  default_node_pool = local.all_pools[0]
  node_pools = length(local.all_pools) > 1 ? {for p in slice(local.all_pools, 1, length(local.all_pools)) : p.name => p} : {}
  credentials = {
    host = "https://${azurerm_kubernetes_cluster.this.fqdn}:443"
    client_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.client_certificate)
    client_key = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
    username = azurerm_kubernetes_cluster.this.kube_config.0.username
    password = azurerm_kubernetes_cluster.this.kube_config.0.password
  }
}