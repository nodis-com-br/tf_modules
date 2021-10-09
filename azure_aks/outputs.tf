output "this" {
  value = azurerm_kubernetes_cluster.this
}

output "vault_auth_backend" {
  value = try(vault_auth_backend.this.0)
}