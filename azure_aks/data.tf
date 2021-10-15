data "local_file" "tunnelfront-patch" {
  filename = "${path.module}/patchs/tunnelfront-patch.yaml"
}

data "kubernetes_service_account" "vault-injector" {
  count = var.vault_auth_backend ? 1 : 0
  metadata {
    name = var.vault_token_reviewer_sa.name
    namespace = var.vault_token_reviewer_sa.namespace
  }
}

data "kubernetes_secret" "vault-injector-token" {
  count = var.vault_auth_backend ? 1 : 0
  metadata {
    name = data.kubernetes_service_account.vault-injector.0.default_secret_name
    namespace = var.vault_token_reviewer_sa.namespace
  }
}

data "dns_a_record_set" "endpoint_ip" {
  host = trimprefix(trimsuffix(azurerm_kubernetes_cluster.this.kube_config.0.host, ":443"), "https://")
}