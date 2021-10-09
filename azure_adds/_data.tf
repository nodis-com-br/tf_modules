data "azurerm_virtual_network" "this" {
  name = "aadds-vnet"
  resource_group_name = var.rg.name
}