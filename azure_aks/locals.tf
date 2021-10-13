locals {
  cluster_name = "${var.rg.name}-${var.name}"
  vault_kv_secrets_path = "secret/k8s/${var.rg.name}"
  default_node_pool_min_count = var.default_node_pool_min_count == null ? var.default_node_pool_node_count : var.default_node_pool_min_count
  default_node_pool_max_count = var.default_node_pool_max_count == null ? var.default_node_pool_node_count : var.default_node_pool_max_count
//  ip_endpont = "https://${data.dns_a_record_set.endpoint_ip.addrs.0}:443"
  kubeconfig = jsonencode({
    raw = azurerm_kubernetes_cluster.this.kube_config_raw
    kubedict = jsonencode({
      cluster = {
        server = azurerm_kubernetes_cluster.this.kube_config.0.host
        certificate-authority-data = azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate
      }
      user = {
        token = azurerm_kubernetes_cluster.this.kube_config.0.password
      }
    })
  })
}