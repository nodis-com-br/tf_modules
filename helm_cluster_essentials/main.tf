module "ghcr_credentials" {
  source = "../helm_release"
  for_each = toset(var.ghcr_credentials_namespaces)
  name = "ghcr-credentials"
  namespace = each.key
  chart = var.ghcr_credentials_chart
  chart_version = var.ghcr_credentials_chart_version
  values = var.ghcr_credentials_values
  providers = {
    helm = helm
  }
}

module "kong_default_override" {
  source = "../helm_release"
  for_each = toset(var.kong_default_override_namespaces)
  name = "default-override"
  namespace = each.key
  chart = var.kong_default_override_chart
  chart_version = var.kong_default_override_chart_version
  values = concat(var.kong_default_override_values, [local.default_values.kong_default_override])
  providers = {
    helm = helm
  }
}

module "endpoint_bots" {
  source = "../helm_release"
  name = "endpoint-bots"
  namespace = var.endpoint_bots_namespace
  chart = var.endpoint_bots_chart
  chart_version = var.endpoint_bots_chart_version
  values = var.endpoint_bots_values
  providers = {
    helm = helm
  }
}

module "newrelic" {
  source = "../helm_release"
  name = "newrelic-bundle"
  namespace = var.newrelic_namespace
  chart = var.newrelic_chart
  chart_version = var.newrelic_chart_version
  repository = var.newrelic_repository
  values = concat(var.newrelic_values, [local.default_values.newrelic])
  providers = {
    helm = helm
  }
}