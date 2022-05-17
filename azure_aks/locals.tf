locals {
  cluster_name = "${var.rg.name}-${var.name}"
  vault_kv_path = "secret/k8s/${local.cluster_name}"
  default_node_pool_min_count = var.default_node_pool_min_count == null ? var.default_node_pool_node_count : var.default_node_pool_min_count
  default_node_pool_max_count = var.default_node_pool_max_count == null ? var.default_node_pool_node_count : var.default_node_pool_max_count
  endpoint_host = trimprefix(trimsuffix(azurerm_kubernetes_cluster.this.kube_config.0.host, ":443"), "https://")
  credentials = {
    host = var.private_cluster_public_fqdn_enabled ? "https://${azurerm_kubernetes_cluster.this.fqdn}:443" : azurerm_kubernetes_cluster.this.kube_config.0.host
    client_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.client_certificate)
    client_key = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
    username = azurerm_kubernetes_cluster.this.kube_config.0.username
    password = azurerm_kubernetes_cluster.this.kube_config.0.password
  }
}