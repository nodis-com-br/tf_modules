resource "azurerm_local_network_gateway" "this" {
  name  = var.name
  resource_group_name = var.rg.name
  location = var.rg.location
  gateway_address = var.gateway_address
  address_space = var.address_space
}