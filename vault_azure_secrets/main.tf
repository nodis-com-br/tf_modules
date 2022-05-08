module "service_principal" {
  source = "../azure_service_principal"
  name = var.service_principal_name
  resource_accesses = var.service_principal_resource_accesses
  roles = var.service_principal_roles
  create_password = true
}

resource "vault_azure_secret_backend" "this" {
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
  environment = var.environment
  client_id = module.service_principal.application.application_id
  client_secret = module.service_principal.password
}

