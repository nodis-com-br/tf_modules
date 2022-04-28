data "vault_generic_secret" "ca" {
  path = "${module.backend.this.path}/cert/ca"
  depends_on = [
    vault_pki_secret_backend_intermediate_set_signed.this
  ]
}
