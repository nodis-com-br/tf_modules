data "kubernetes_service_account" "vault-injector" {
  provider = kubernetes
  count = length(var.vault_injector_values) > 0 ? 1 : 0
  metadata {
    name = var.vault_token_reviewer_sa.name
    namespace = var.vault_token_reviewer_sa.namespace
  }
  depends_on = [
    module.vault_injector
  ]
}

data "kubernetes_secret" "vault-injector-token" {
  provider = kubernetes
  count = length(var.vault_injector_values) > 0 ? 1 : 0
  metadata {
    name = data.kubernetes_service_account.vault-injector.0.default_secret_name
    namespace = var.vault_token_reviewer_sa.namespace
  }
  depends_on = [
    module.vault_injector
  ]
}

data "kubernetes_secret" "rabbitmq_default_user" {
  provider = kubernetes
  count = length(var.rabbitmq_chart_values) > 0 ? 1 : 0
  metadata {
    name = "${var.rabbitmq_name}-default-user"
    namespace = var.rabbitmq_namespace
  }
}

data "kubernetes_service" "rabbitmq" {
  provider = kubernetes
  count = length(var.rabbitmq_chart_values) > 0 ? 1 : 0
  metadata {
    name = var.rabbitmq_name
    namespace = var.rabbitmq_namespace
  }
}