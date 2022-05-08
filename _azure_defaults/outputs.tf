output "azure" {
  value = local.azure
}

output "azure_config" {
  value = data.azurerm_client_config.current
}