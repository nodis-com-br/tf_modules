resource "kubectl_manifest" "this" {
  for_each = {for d in local.http_manifests : md5(d) => d}
  yaml_body = each.value
}