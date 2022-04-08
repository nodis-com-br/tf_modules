resource "azurerm_public_ip" "nat_gateway" {
  name  = "${var.name}-nat-gateway"
  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location
  allocation_method = "Static"
  sku = "Standard"
  sku_tier = "Regional"
  zones = [1, 2, 3]
}

resource "azurerm_nat_gateway" "this" {
  name = var.name
  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  nat_gateway_id = azurerm_nat_gateway.this.id
  public_ip_address_id = azurerm_public_ip.nat_gateway.id
}