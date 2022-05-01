resource "kubectl_manifest" "this" {
  for_each = {for d in local.manifests : d.id  => d.yaml}
  yaml_body = each.value
  depends_on = [
    data.httpclient_request.this
  ]
}