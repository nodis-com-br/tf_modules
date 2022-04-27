output "this" {
  value = module.backend.this
}

output "ca_cert" {
  value = data.vault_generic_secret.ca.data.certificate
}

output "csr" {
  value = vault_pki_secret_backend_intermediate_cert_request.this.csr
}