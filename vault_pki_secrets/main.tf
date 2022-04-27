module "backend" {
  source = "../vault_mount"
  path = var.path
  type = var.backend_type
}

resource "vault_pki_secret_backend_intermediate_cert_request" "this" {
  backend = module.backend.this.path
  type = var.type
  common_name = var.common_name
}

resource "vault_pki_secret_backend_root_sign_intermediate" "this" {
  count = var.root_ca_pki_path != null ? 1 : 0
  backend = var.root_ca_pki_path
  csr = vault_pki_secret_backend_intermediate_cert_request.this.csr
  ttl = var.ttl
  common_name = var.common_name
}

resource "vault_pki_secret_backend_intermediate_set_signed" "this" {
  backend = module.backend.this.path
  certificate = var.signed_certificate != null ? var.signed_certificate : vault_pki_secret_backend_root_sign_intermediate.this[0].certificate
}