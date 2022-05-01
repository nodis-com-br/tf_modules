output "this" {
  value = module.backend.this
}

output "csr" {
  value = vault_pki_secret_backend_intermediate_cert_request.this.csr
}

output "certificate" {
  value = vault_pki_secret_backend_intermediate_set_signed.this.certificate
}