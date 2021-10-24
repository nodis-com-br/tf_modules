module "auth_backend" {
  source = "../vault_auth_backend"
  type = "kubernetes"
  path = var.path
}

resource "vault_kubernetes_auth_backend_config" "this" {
  backend = module.auth_backend.this.path
  kubernetes_host = var.host
  kubernetes_ca_cert = var.ca_certificate
  token_reviewer_jwt = var.token
  disable_iss_validation = true
  pem_keys = []
}