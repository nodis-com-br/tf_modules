output "this" {
  value = azurerm_kubernetes_cluster.this
}

output "vault_auth_backend" {
  value = var.vault_auth_backend ? vault_auth_backend.this.0 : null
}

output "temp" {
  value = typ
}