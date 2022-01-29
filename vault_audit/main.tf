resource "vault_generic_endpoint" "this" {
  path = "sys/audit/${var.name}"
  ignore_absent_fields = true
  disable_read = true
  data_json = jsonencode(var.config)
}