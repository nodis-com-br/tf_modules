data "helm_template" "this" {
  name = var.name
  namespace = var.namespace
  repository = var.repository
  chart = var.chart
  values = var.values
}
