resource "vault_azure_secret_backend" "this" {
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
  environment = var.environment
  client_id = var.client_id
  client_secret = var.client_secret
}