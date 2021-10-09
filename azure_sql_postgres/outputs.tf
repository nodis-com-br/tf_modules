output "access_info" {
  value = {
    private_endpoint = azurerm_private_endpoint.this.0.private_service_connection.0.private_ip_address
    postgres_password = random_password.postgres_password.result
  }
}