output "network_interfaces" {
  value = azurerm_network_interface.this
}

output "public_ips" {
  value = try(azurerm_public_ip.this)
}

output "load_balancer_ip" {
  value = try(azurerm_public_ip.lb[0], null)
}