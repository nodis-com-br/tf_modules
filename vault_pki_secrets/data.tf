data "vault_generic_secret" "ca" {
  path = "${module.backend.this.path}/cert/ca"
}
