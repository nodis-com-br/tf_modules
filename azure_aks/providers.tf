provider "kubernetes" {
  host = azurerm_kubernetes_cluster.this.kube_config.0.host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
  token = azurerm_kubernetes_cluster.this.kube_config.0.password
}
