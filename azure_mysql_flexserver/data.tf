data "external" "resolver" {
  program = ["${path.module}/scripts/resolve_azure_private_host.sh", "${azurerm_mysql_flexible_server.this.name}.${var.private_dns_zone.name}"]
}