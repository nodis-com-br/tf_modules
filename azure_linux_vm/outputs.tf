output "this" {
  value = azurerm_linux_virtual_machine.this
}

output "network_interfaces" {
  value = azurerm_network_interface.this
}

output "public_ips" {
  value = [for ip in azurerm_public_ip.this : ip.ip_address]
}