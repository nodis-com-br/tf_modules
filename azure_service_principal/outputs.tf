output "this" {
  value = azuread_service_principal.this
}

output "application" {
  value = azuread_application.this
}

output "password" {
  value = try(azuread_service_principal_password.this.0.value, null)
}