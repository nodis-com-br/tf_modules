resource "azurerm_virtual_network_peering" "this" {
  for_each = var.peering_vnets
  name = "${each.key}-aadds"
  resource_group_name = var.rg.name
  virtual_network_name = data.azurerm_virtual_network.this.name
  remote_virtual_network_id = each.value.id
}
