resource "azurerm_managed_disk" "this" {
  name = var.name
  location = var.rg.location
  resource_group_name = var.rg.name
  storage_account_id = var.storage_account.id
  storage_account_type = "Standard_LRS"
  create_option = "Import"
  source_uri = var.source_uri
}