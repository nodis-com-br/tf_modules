module "redis" {
  source = "../helm_release"
  name = var.name
  namespace = var.namespace
  chart = var.helm_chart
  chart_version = var.helm_chart_version
  repository = var.helm_chart_repository
  create_namespace = true
  values = concat(var.helm_chart_values, [
    jsonencode({
      fullnameOverride = var.name
      architecture = "standalone"
      auth = {enabled = false}
      metrics = {enabled = false}
    })
  ])
  providers = {
    helm = helm
  }
}
