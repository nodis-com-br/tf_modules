locals {
  name = "${var.name_prefix}-${var.rg.name}-${var.name}"
  short_name = "${var.rg.name}-${var.name}"
  address = var.private_endpoint ? aws_route53_record.this.0.fqdn : azurerm_postgresql_server.this.fqdn
  database_backends = concat(["postgres"], var.vault_database_backends)
}