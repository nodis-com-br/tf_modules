locals {
  cluster_name = "${var.rg.name}-${var.name}"
  default_node_pool = [for k, v in var.node_pools : merge(v, {name = k}) if v.default == true][0]
  node_pools = {for k, v in var.node_pools : k => v if v.default != true}
  credentials = {
    host = "https://${azurerm_kubernetes_cluster.this.fqdn}:443"
    client_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.client_certificate)
    client_key = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
  }
}