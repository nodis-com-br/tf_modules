data "httpclient_request" "this" {
  url = var.url
}

data "kubectl_file_documents" "this" {
  content = data.httpclient_request.this.response_body
}