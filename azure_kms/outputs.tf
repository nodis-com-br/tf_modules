output "key_vault_name" {
  value = azurerm_key_vault.this.name
}

output "service_principal" {
  value = {
    tenant_id = var.tenant_id
    client_id = azuread_application.this.application_id
    client_secret = azuread_service_principal_password.this.value
  }
}