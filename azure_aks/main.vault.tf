### Secrets ###########################

resource "vault_generic_secret" "this" {
  path = "${local.vault_kv_secrets_path}/${local.cluster_name}/root"
  data_json = local.kubeconfig
}

resource "vault_generic_secret" "default" {
  count = var.default ? 1 : 0
  path = "${local.vault_kv_secrets_path}/default/root"
  data_json = local.kubeconfig
}

resource "vault_generic_secret" "endpoint" {
  path = "${local.vault_kv_secrets_path}/${local.cluster_name}"
  data_json = jsonencode({
    endpoint = azurerm_kubernetes_cluster.this.kube_config.0.host
    address = data.dns_a_record_set.endpoint_ip.addrs.0
  })
}

resource "vault_generic_secret" "endpoint-default" {
  count = var.default ? 1 : 0
  path = "${local.vault_kv_secrets_path}/default"
  data_json = jsonencode({
    endpoint = azurerm_kubernetes_cluster.this.kube_config.0.host
    address = data.dns_a_record_set.endpoint_ip.addrs.0
  })
}


### Vault auth backend ################

resource "vault_auth_backend" "this" {
  count = var.vault_auth_backend ? 1 : 0
  type = "kubernetes"
  path = local.cluster_name
}

resource "vault_kubernetes_auth_backend_config" "this" {
  count = var.vault_auth_backend ? 1 : 0
  backend = vault_auth_backend.this.0.path
  kubernetes_host = azurerm_kubernetes_cluster.this.kube_config.0.host
  kubernetes_ca_cert = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
  token_reviewer_jwt = data.kubernetes_secret.vault-injector-token.0.data.token
  disable_iss_validation = true
  pem_keys = []
}

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