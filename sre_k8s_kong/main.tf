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
    jsonencode({
      ingressController = {ingressClass = local.instances[each.value]["ingress_class"]}
      nameOverride = "proxy"
      proxy = {
        externalTrafficPolicy =  "Local"
        http = {containerPort = 80}
        tls = {containerPort = 443}
        annotations = {
          "service.beta.kubernetes.io/aws-load-balancer-backend-protocol" = "tcp"
          "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
        }
      }
      autoscaling = {
        enabled = true
        minReplicas = 1
        maxReplicas = 3
      }
      securityContext = {runAsUser = 0}
      serviceMonitor = {enabled = true}
      admin = {tls = {parameters = []}}
    })
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
  values = [jsonencode({
    annotations = {"kubernetes.io/ingress.class" = each.value["ingress_class"]}
    route = {
      protocols = ["https"]
      https_redirect_status_code = 302
      strip_path = true
    }
  })]
  providers = {
    helm = helm
  }
}