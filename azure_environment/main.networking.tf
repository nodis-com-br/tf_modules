### Virtual Network ###################

resource "azurerm_virtual_network" "this" {
  name = var.name
  address_space = [var.address_space]
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_servers = var.vnet_dns_servers

}

# NAT Gateway #####

resource "azurerm_public_ip" "nat_gateway" {
  name  = "${var.name}-nat-gateway"
  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location
  allocation_method = "Static"
  sku = "Standard"
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

# VPN Gateway

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

# Subnets #########

resource "azurerm_subnet" "this" {
  count = var.subnets
  name = "subnet${format("%04.0f", count.index + 1)}"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = [cidrsubnet(var.address_space, var.subnet_newbits, count.index)]
  enforce_private_link_endpoint_network_policies = true
  address_prefix = null
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  count = var.associate_nat_gateway ? var.subnets : 0
  subnet_id = azurerm_subnet.this[count.index].id
  nat_gateway_id = azurerm_nat_gateway.this.id
}

# VPN Gateway Subnet

resource "azurerm_subnet" "gateway_subnet" {
  count = var.vpn_gateway ? 1 : 0
  name = "GatewaySubnet"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = [cidrsubnet(var.address_space, var.subnet_newbits, 63)]
  address_prefix = null
}

# Peering #########

resource "azurerm_virtual_network_peering" "this" {
  for_each = var.peering_connections
  name = each.key
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  remote_virtual_network_id = each.value.id
}