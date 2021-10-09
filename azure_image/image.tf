resource "azurerm_image" "this" {
  name = var.name
  location = var.rg.location
  resource_group_name = var.rg.name
  os_disk {
    os_type  = var.os_type
    os_state = "Generalized"
    blob_uri = var.source_uri
    size_gb  = 8
  }
}