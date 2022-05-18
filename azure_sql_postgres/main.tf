resource "random_password" "postgres_password" {
  length  = 16
  special = false
}

resource "azurerm_postgresql_server" "this" {
  name = "${var.name_prefix}-${var.rg.name}-${var.name}"
  resource_group_name = var.rg.name
  location = var.rg.location
  sku_name = var.sku_name
  storage_mb = var.storage
  backup_retention_days = var.backup_retention_days
  geo_redundant_backup_enabled = false
  auto_grow_enabled = var.auto_grow
  administrator_login = var.admin_username
  administrator_login_password = random_password.postgres_password.result
  version = var.psql_version
  ssl_enforcement_enabled = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
  public_network_access_enabled = var.public_access

  tags = var.tags
  lifecycle {
    ignore_changes = [
      storage_mb
    ]
  }
}

resource "azurerm_postgresql_firewall_rule" "this" {
  for_each = var.allowed_sources
  name = each.key
  resource_group_name = azurerm_postgresql_server.this.resource_group_name
  server_name = azurerm_postgresql_server.this.name
  start_ip_address = each.value.start_address
  end_ip_address = try(each.value.end_address, each.value.start_address)
}

resource "azurerm_private_endpoint" "this" {
  count = var.private_endpoint ? 1 : 0
  name = azurerm_postgresql_server.this.name
  location = azurerm_postgresql_server.this.location
  resource_group_name = azurerm_postgresql_server.this.resource_group_name
  subnet_id = var.subnet.id
  private_service_connection {
    name = "${azurerm_postgresql_server.this.name}-privateserviceconnection"
    private_connection_resource_id = azurerm_postgresql_server.this.id
    subresource_names = ["postgresqlServer"]
    is_manual_connection = false
  }
}

resource "aws_route53_record" "this" {
  provider = aws.dns
  count = var.private_endpoint ? 1 : 0
  zone_id = var.route53_zone_id
  name = "${azurerm_postgresql_server.this.resource_group_name}-${var.name}.${var.private_domain}"
  type = "A"
  ttl = "300"
  records = [
    azurerm_private_endpoint.this.0.private_service_connection.0.private_ip_address
  ]
}

module "vault_secrets_backend" {
  source = "../vault_mount"
  path = "postgres/${var.rg.name}-${var.name}"
  type = "database"
}
