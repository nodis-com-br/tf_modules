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
  count = var.kubernetes_auth_backend == null ? 0 : 1
  backend = var.kubernetes_auth_backend
  name = "${var.environment}_${var.name}"
  bound_service_account_names = ["${var.name}-server"]
  bound_service_account_namespaces = [var.namespace]
  policy_definitions = [for p in var.vault_policy_definitions : format(p, "${var.environment}-${var.name}")]
}

module "rabbitmq" {
  source = "../helm_release"
  name = var.name
  namespace = var.namespace
  chart = var.helm_chart
  chart_version = var.helm_chart_version
  repository = var.helm_chart_repository
  values = concat(var.helm_chart_values,
    var.vault_values != null ? [format(var.vault_values, "${var.vault_kv_backend.path}data/${var.vault_secret_path}", module.rabbitmq_k8s_auth_role[0].this.role_name)] : [],
    var.tls_values != null ? [format(var.tls_values, "${var.name}-certificate")] : [],
    var.tls_service_annotation_values != null ? [format(var.tls_service_annotation_values, "${var.name}-certificate", "${var.name}.${var.subdomain}")] : [],
  )
  providers = {
    helm = helm
  }
}
