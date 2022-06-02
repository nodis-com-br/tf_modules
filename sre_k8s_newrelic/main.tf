module "newrelic" {
  source = "../helm_release"
  count = length(var.values) > 0 ? 1 : 0
  name = "newrelic-bundle"
  namespace = var.namespace
  chart = var.chart_name
  chart_version = var.chart_version
  repository = var.helm_charts_repository
  values = var.values
  create_namespace = true
  providers = {
    helm = helm
  }
}
