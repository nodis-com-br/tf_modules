data "kubernetes_service_account" "vault-injector" {
  metadata {
    name = var.token_reviewer_sa.name
    namespace = var.token_reviewer_sa.namespace
  }
}

data "kubernetes_secret" "vault-injector-token" {
  metadata {
    name = data.kubernetes_service_account.vault-injector.default_secret_name
    namespace = var.token_reviewer_sa.namespace
  }
}
