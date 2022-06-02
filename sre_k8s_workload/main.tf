module "workload" {
  source = "../helm_release"
  name = var.name
  chart = var.helm_chart
  chart_version = var.helm_chart_version
  repository = var.helm_chart_repository
  namespace = var.namespace
  values = var.helm_chart_values
  providers = {
    helm = helm
  }
}

resource "null_resource" "set_latest_tag" {
  triggers = {
    repository = local.rendered_values["image"]["repository"]
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = "kubectl set image --kubeconfig <(echo '${var.kubeconfig}') --namespace ${var.namespace} ${var.helm_chart}/${var.name} ${var.name}=${var.registry}/${module.workload.values["image"]["repository"]}${data.external.current_version.result.tag}"
  }
  depends_on = [
    module.workload.this,
    data.external.current_version
  ]
}


