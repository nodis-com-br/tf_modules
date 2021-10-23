### Vault secret engine ##############

resource "vault_mount" "this" {
  path = "k8s/${local.cluster_name}"
  type = "vault-k8s-secret-engine"
  options = {
    jwt = azurerm_kubernetes_cluster.this.kube_config.0.password
    host = azurerm_kubernetes_cluster.this.kube_config.0.host
    ca_cert = azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate
    admin_role = "admin"
    editor_role = "edit"
    viewer_role = "view"
    max_ttl = "720h"
  }
}

### Secrets ###########################

resource "vault_generic_secret" "this" {
  path = "${local.vault_kv_path}/kubeconfig/root"
  data_json = jsonencode({
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

resource "vault_generic_secret" "endpoint" {
  path = "${local.vault_kv_path}/endpoint"
  data_json = jsonencode({
    uri = azurerm_kubernetes_cluster.this.kube_config.0.host
    host = local.endpoint_host
    address = data.dns_a_record_set.endpoint_host.addrs.0
  })
}




