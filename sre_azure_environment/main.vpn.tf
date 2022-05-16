resource "azurerm_public_ip" "virtual_network_gateway" {
  count = var.vpn_gateway ? 1 : 0
  name  = "${var.name}_virtual-network-gateway"
  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location
  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "this" {
  count = var.vpn_gateway ? 1 : 0
  name  = var.name
  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location
  type = "Vpn"
  vpn_type = "RouteBased"
  active_active = false
  enable_bgp = false
  sku = "VpnGw1"
  ip_configuration {
    name = "vnetGatewayConfig"
    public_ip_address_id = azurerm_public_ip.virtual_network_gateway.0.id
    private_ip_address_allocation = "Dynamic"
    subnet_id = azurerm_subnet.gateway_subnet.0.id
  }
}

resource "azurerm_subnet" "gateway_subnet" {
  count = var.vpn_gateway ? 1 : 0
  name = "GatewaySubnet"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = [cidrsubnet(var.address_space, var.subnet_newbits, 63)]
}