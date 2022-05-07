resource "vault_generic_endpoint" "this" {
  path = "${try(var.backend.path, var.backend)}/roles/${var.name}"
  ignore_absent_fields = true
  disable_read = true
  data_json = jsonencode({
    cidr_blocks = var.cidr_blocks
    database_name = var.database_name
    ip_addresses = var.ip_addresses
    organization_id =  var.organization_id
    roles = var.roles
    ttl = var.ttl
    max_ttl = var.max_ttl
  })
}
