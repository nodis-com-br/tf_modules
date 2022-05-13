data "kubernetes_service_account" "vault-injector" {
  provider = kubernetes
  count = length(var.vault_injector_chart_values) > 0 ? 1 : 0
  metadata {
    name = var.vault_token_reviewer_sa
    namespace = var.vault_injector_chart_namespace
  }
  depends_on = [
    module.vault_injector
  ]
}

data "kubernetes_secret" "vault-injector-token" {
  provider = kubernetes
  count = length(var.vault_injector_chart_values) > 0 ? 1 : 0
  metadata {
    name = data.kubernetes_service_account.vault-injector[0].default_secret_name
    namespace = data.kubernetes_service_account.vault-injector[0].metadata[0].namespace
  }
}