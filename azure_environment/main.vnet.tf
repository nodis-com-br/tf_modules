resource "azurerm_virtual_network" "this" {
  name = var.name
  address_space = [var.address_space]
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_servers = var.vnet_dns_servers
}

resource "azurerm_virtual_network_peering" "this" {
  for_each = var.peering_connections
  name = each.key
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  remote_virtual_network_id = each.value.id
}

resource "azurerm_subnet" "this" {
  count = var.subnets
  name = "subnet${format("%04.0f", count.index + 1)}"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = [cidrsubnet(var.address_space, var.subnet_newbits, count.index)]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  count = var.associate_nat_gateway ? var.subnets : 0
  subnet_id = azurerm_subnet.this[count.index].id
  nat_gateway_id = azurerm_nat_gateway.this.id
}
