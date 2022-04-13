resource "kubectl_manifest" "this" {
  for_each = var.type == "http" ? {for d in local.http_manifests : d.id  => d.yaml} : {}
  yaml_body = each.value
}