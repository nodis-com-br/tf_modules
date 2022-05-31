locals {
  instances = {
    public = {
      ingress_class = "kong-public"
      values = var.public_chart_values
      default_override_namespaces = var.default_override_public_namespaces
    }
    private = {
      ingress_class = "kong-private"
      values = concat(var.private_chart_values, [
        jsonencode({proxy = {annotations = {
          "service.beta.kubernetes.io/aws-load-balancer-internal" = "true"
          "service.beta.kubernetes.io/azure-load-balancer-internal" = "true"
        }}}),
      ])
      default_override_namespaces = var.default_override_private_namespaces
    }
  }

}