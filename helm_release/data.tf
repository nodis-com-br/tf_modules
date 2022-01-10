data "helm_template" "this" {
  provider = helm.current
  name = var.name
  namespace = var.namespace
  repository = var.repository
  chart = var.chart
  values = var.values
}
