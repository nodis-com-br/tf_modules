resource "helm_release" "this" {
  provider = helm
  name = var.name
  namespace = var.namespace
  repository = var.repository
  chart = var.chart
  version = var.chart_version
  values = var.values
  max_history = var.max_history
  create_namespace = var.create_namespace
  cleanup_on_fail = var.cleanup_on_fail
  timeout = var.timeout
  wait = var.wait
}
