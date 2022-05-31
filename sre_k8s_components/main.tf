# Vault #######################################################################

module "vault_injector" {
  source = "../helm_release"
  count = length(var.vault_injector_chart_values) > 0 ? 1 : 0
  name = "vault-injector"
  namespace = var.vault_injector_chart_namespace
  chart = var.vault_chart
  chart_version = var.vault_chart_version
  repository = var.vault_chart_repository
  create_namespace = true
  values = var.vault_injector_chart_values
  providers = {
    helm = helm
  }
}

# botland #####################################################################

module "endpoint_bots_k8s_auth_role" {
  source = "../vault_k8s_auth_role"
  count = length(var.endpoint_bots_vault_policy_definitions) > 0 ? 1 : 0
  backend = "kubernetes/${var.cluster.this.name}"
  name = var.endpoint_bots_name
  bound_service_account_names = [var.endpoint_bots_name]
  bound_service_account_namespaces = [var.bots_namespace]
  policy_definitions = var.endpoint_bots_vault_policy_definitions
}

module "endpoint_bots" {
  source = "../helm_release"
  count = length(var.endpoint_bots_chart_values) > 0 ? 1 : 0
  name = var.endpoint_bots_name
  namespace = var.bots_namespace
  chart = var.endpoint_bots_chart
  chart_version = var.endpoint_bots_chart_version
  repository = var.helm_chart_repository
  create_namespace = true
  values = var.endpoint_bots_chart_values
  depends_on = [
    module.endpoint_bots_k8s_auth_role[0]
  ]
  providers = {
    helm = helm
  }
}

module "ghcr_credentials_bot_k8s_auth_role" {
  source = "../vault_k8s_auth_role"
  count = length(var.ghcr_credentials_bot_vault_policy_definitions) > 0 ? 1 : 0
  backend = "kubernetes/${var.cluster.this.name}"
  name = var.ghcr_credentials_bot_name
  bound_service_account_names = [var.ghcr_credentials_bot_name]
  bound_service_account_namespaces = [var.bots_namespace]
  policy_definitions = var.ghcr_credentials_bot_vault_policy_definitions
}

module "ghcr_credentials_bot" {
  source = "../helm_release"
  count = length(var.ghcr_credentials_bot_chart_values) > 0 ? 1 : 0
  name = var.ghcr_credentials_bot_name
  namespace = var.bots_namespace
  chart = var.vault_bot_chart
  chart_version = var.vault_bot_chart_version
  repository = var.helm_chart_repository
  create_namespace = true
  values = var.ghcr_credentials_bot_chart_values
  depends_on = [
    module.ghcr_credentials_bot_k8s_auth_role[0]
  ]
  providers = {
    helm = helm
  }
}

# NewRelic ####################################################################

module "newrelic" {
  source = "../helm_release"
  count = length(var.newrelic_values) > 0 ? 1 : 0
  name = "newrelic-bundle"
  namespace = var.newrelic_namespace
  chart = var.newrelic_chart
  chart_version = var.newrelic_chart_version
  repository = var.newrelic_repository
  values = var.newrelic_values
  create_namespace = true
  providers = {
    helm = helm
  }
}
