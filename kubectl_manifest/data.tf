data "http" "this" {
  for_each = toset(var.sources)
  url = each.value
}

data "kubectl_file_documents" "http" {
  for_each = toset(var.sources)
  content = data.http.this[each.key].body
}