output "this" {
  value = azurerm_kubernetes_cluster.this
}

output "credentials" {
  value = local.credentials
}

#output "outbound_ip" {
#  value = data.azurerm_public_ip.outbound.ip_address
#}