resource "vault_generic_endpoint" "this" {
  path = "sys/plugins/catalog/${var.type}/${var.name}"
  ignore_absent_fields = true
  disable_read = true
  data_json = jsonencode({
    command = var.command
    sha256 = var.sha256
    args = var.args
  })
}