data "external" "running_tag" {
  program = ["${path.module}/scripts/get_running_image_tag.sh", var.kubeconfig, var.namespace, var.helm_chart, var.name]
}