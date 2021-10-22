resource "vault_auth_backend" "this" {
  type = "kubernetes"
  path = var.path
}

resource "vault_kubernetes_auth_backend_config" "this" {
  backend = vault_auth_backend.this.0.path
  kubernetes_host = var.host
  kubernetes_ca_cert = var.ca_certificate
  token_reviewer_jwt = var.token
  disable_iss_validation = true
  pem_keys = []
}