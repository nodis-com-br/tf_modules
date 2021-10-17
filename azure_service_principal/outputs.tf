output "application" {
  value = azuread_application.this
}

output "password" {
  value = var.create_password ? azuread_service_principal_password.this.0 : null
}