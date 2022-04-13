resource "kubectl_manifest" "this" {
  for_each = {for d in local.http_manifests : d.id => d}
  yaml_body = each.value
}