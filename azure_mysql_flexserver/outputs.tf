output "this" {
  value = azurerm_mysql_flexible_server.this
}

output "credentials" {
  value = {
    host = data.external.resolver.result.ip_address
#    host = data.external.ip_address.result.aRecords[0]["ipv4Address"]
    port = 3306
    username = azurerm_mysql_flexible_server.this.administrator_login
    password = random_password.this.result
  }
}

