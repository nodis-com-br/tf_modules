resource "random_password" "this" {
  count = var.vault_secret_path == null ? 0 : 1
  length  = 16
  special = false
}

module "vault_kv_secret" {
  source = "../vault_secret"
  count = var.vault_secret_path == null ? 0 : 1
  path = var.vault_secret_path
  backend = var.vault_kv_backend
  data_json = jsonencode({
    username = "admin"
    password = random_password.this[0].result
  })
}

module "rabbitmq_k8s_auth_role" {
  source = "../vault_k8s_auth_role"
  count = var.vault_role == null ? 0 : 1
  backend = try(var.kubernetes_auth_backend.path, var.kubernetes_auth_backend)
  name = var.vault_role
  bound_service_account_names = ["${var.name}-server"]
  bound_service_account_namespaces = [var.namespace]
  policy_definitions = var.vault_policy_definitions
}

module "rabbitmq" {
  source = "../helm_release"
  name = var.name
  namespace = var.namespace
  chart = var.helm_chart
  chart_version = var.helm_chart_version
  repository = var.helm_chart_repository
  values = var.helm_chart_values
  providers = {
    helm = helm
  }
}
