output "application" {
  value = azuread_application.this
}

output "password" {
  value = azuread_service_principal_password.this.0
}