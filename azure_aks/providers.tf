provider "kubernetes" {
  host = var.private_cluster_public_fqdn_enabled ? "https://${azurerm_kubernetes_cluster.this.fqdn}:443" : azurerm_kubernetes_cluster.this.kube_config.0.host
  client_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.client_certificate)
  client_key = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
}
