resource "vault_auth_backend" "this" {
  type = "azure"
}

resource "vault_azure_auth_backend_config" "example" {
  backend       = vault_auth_backend.this.path
  tenant_id     = "11111111-2222-3333-4444-555555555555"
  client_id     = "11111111-2222-3333-4444-555555555555"
  client_secret = "01234567890123456789"
  resource      = "https://vault.hashicorp.com"
}