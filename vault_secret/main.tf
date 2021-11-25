resource "vault_generic_secret" "this" {
  path = "${var.backend.path}${var.path}"
  data_json = var.data_json
}