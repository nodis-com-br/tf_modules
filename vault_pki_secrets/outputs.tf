output "this" {
  value = module.backend.this
}

output "csr" {
  value = vault_pki_secret_backend_intermediate_cert_request.this.csr
}