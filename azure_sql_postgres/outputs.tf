output "this" {
  value = azurerm_postgresql_server.this
}

output "credentials" {
  value = {
    host = var.private_endpoint ? aws_route53_record.this.0.fqdn : azurerm_postgresql_server.this.fqdn
    port = 5432
    username = "${var.admin_username}@${azurerm_postgresql_server.this.name}"
    password = random_password.postgres_password.result
  }
}

output "vault_secrets_backend" {
  value = module.vault_secrets_backend.this
}