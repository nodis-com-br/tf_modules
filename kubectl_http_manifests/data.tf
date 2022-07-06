data "httpclient_request" "this" {
  url = var.url
}

data "kubectl_file_documents" "http" {
  content = data.httpclient_request.this["response_body"]
}