resource "kubectl_manifest" "this" {
  for_each = var.manifests
  yaml_body = each.value
}