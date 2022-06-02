module "vault_auth_role" {
  source = "../vault_k8s_auth_role"
  backend = var.vault_auth_backend
  name = coalesce(var.vault_role_name, var.name)
  bound_service_account_names = [coalesce(var.service_account_name, var.name)]
  bound_service_account_namespaces = [var.namespace]
  policy_definitions = var.vault_policies
}

module "vault_bot" {
  source = "../helm_release"
  name = var.name
  namespace = var.namespace
  chart = var.chart_name
  chart_version = var.chart_version
  repository = var.helm_chart_repository
  values = concat(var.chart_values, [
    jsonencode({pod = {annotations = {"vault.hashicorp.com/role" = module.vault_auth_role.this.role_name}}})
  ])
  providers = {
    helm = helm
  }
}