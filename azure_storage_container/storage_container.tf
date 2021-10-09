resource "azurerm_storage_container" "this" {
  name  = var.name
  storage_account_name  = var.storage_account.name
  container_access_type = var.container_access_type
}