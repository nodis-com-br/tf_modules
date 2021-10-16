module "service_principal" {
  source = "../azure_service_principal"
  name = "vault"
  create_password = true
  builtin_resource_access = ["aad_admin"]
  builtin_roles = ['owner']
}



resource "vault_azure_secret_backend" "this" {
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
  environment = var.environment
  client_id = var.client_id
  client_secret = var.client_secret
}