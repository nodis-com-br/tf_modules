module "plugin" {
  source = "../helm_release"
  name = var.name
  namespace = var.namespace
  chart = var.plugin_chart
  chart_version = var.plugin_chart_version
  repository = var.charts_repository
  values = [
    jsonencode({annotations = {"kubernetes.io/ingress.class" = var.ingress_class}}),
    jsonencode({plugin: "basic-auth"})
  ]
  providers = {
    helm = helm
  }
}

module "consumer" {
  source = "../helm_release"
  for_each = {for c in var.consumers : c["username"] => c}
  name = "${var.name}-${each.value["username"]}"
  namespace = var.namespace
  chart = var.consumer_chart
  chart_version = var.consumer_chart_version
  repository = var.charts_repository
  values = [
    jsonencode({annotations = {"kubernetes.io/ingress.class" = var.ingress_class}}),
    jsonencode({username = each.value["username"], password = each.value["password"]})
  ]
  providers = {
    helm = helm
  }
}