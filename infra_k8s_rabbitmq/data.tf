data "kubernetes_secret" "default_user" {
  provider = kubernetes
  count = length(var.helm_chart_values) > 0 ? 1 : 0
  metadata {
    name = "${var.name}-default-user"
    namespace = var.namespace
  }
}

data "kubernetes_service" "this" {
  provider = kubernetes
  count = length(var.helm_chart_values) > 0 ? 1 : 0
  metadata {
    name = var.name
    namespace = var.namespace
  }
}