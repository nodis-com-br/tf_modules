resource "vault_generic_secret" "this" {
  path = "${try(var.backend.path, var.backend)}${var.path}"
  data_json = var.data_json
}