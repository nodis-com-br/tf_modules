data "httpclient_request" "this" {
  for_each = toset(var.type == "http" ? var.sources : [])
  url = each.value
}

data "kubectl_file_documents" "http" {
  for_each = toset(var.type == "http" ? var.sources : [])
  content = data.httpclient_request.this[each.key].response_body
}