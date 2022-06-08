output "rg" {
  value = azurerm_resource_group.this
}

output "vnet" {
  value = azurerm_virtual_network.this
}

output "nat_gateway" {
  value = azurerm_nat_gateway.this
}

output "nat_gateway_public_ip" {
  value = azurerm_public_ip.nat_gateway
}

output "vpn_gateway_public_ip" {
  value = azurerm_public_ip.virtual_network_gateway
}

output "ssh_key" {
  value = azurerm_ssh_public_key.this
}

output "subnets" {
  value = azurerm_subnet.this
}

output "storage_account" {
  value = azurerm_storage_account.this
}