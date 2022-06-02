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
