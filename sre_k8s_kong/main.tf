module "kong" {
  source = "../helm_release"
  for_each = toset(var.instances)
  name = local.instances[each.value]["ingress_class"]
  namespace = var.namespace
  chart = var.kong_chart
  chart_version = var.kong_chart_version
  repository = var.kong_chart_repository
  create_namespace = true
  skip_crds = true
  values = concat(local.instances[each.value]["values"], [
    jsonencode({ingressController = {ingressClass = local.instances[each.value]["ingress_class"]}}),
    jsonencode({nameOverride = "proxy"}),
    jsonencode({proxy = {externalTrafficPolicy =  "Local"}}),
    jsonencode({proxy = {http = {containerPort = 80}}}),
    jsonencode({proxy = {tls = {containerPort = 443}}}),
    jsonencode({proxy = {annotations = {"service.beta.kubernetes.io/aws-load-balancer-backend-protocol" = "tcp"}}}),
    jsonencode({proxy = {annotations = {"service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"}}}),
    jsonencode({autoscaling = {enabled = true}}),
    jsonencode({autoscaling = {minReplicas = 1}}),
    jsonencode({autoscaling = {maxReplicas = 3}}),
    jsonencode({securityContext = {runAsUser = 0}}),
    jsonencode({serviceMonitor = {enabled = true}}),
    jsonencode({admin = {tls = {parameters = []}}}),
  ])
  providers = {
    helm = helm
  }
}


module "kongingress_default_override" {
  source = "../helm_release"
  for_each = {for i in flatten([for c in var.instances : [for n in local.instances[c]["default_override_namespaces"] : {
    instance = c
    ingress_class = local.instances[c]["ingress_class"]
    namespace = n
  }]]) : "${i["instance"]}-${i["namespace"]}" => i}
  name = "default-override-${each.value["instance"]}"
  namespace = each.value["namespace"]
  chart = var.kongingress_chart
  repository = var.kongingress_chart_repository
  chart_version = var.kongingress_chart_version
  values = [
    jsonencode({annotations = {"kubernetes.io/ingress.class" = each.value["ingress_class"]}}),
    jsonencode({route = {protocols = ["https"]}}),
    jsonencode({route = {https_redirect_status_code = 302}}),
    jsonencode({route = {strip_path = true}}),
  ]
  providers = {
    helm = helm
  }
}