module "service_principal" {
  source = "../azure_service_principal"
  name = var.service_principal_name
  create_password = true
  resource_accesses =var.service_principal_resource_accesses
  homepage_url = var.homepage_url
}

module "auth_backend" {
  source = "../vault_auth_backend"
  type = "azure"
  path = var.path
}

resource "vault_azure_auth_backend_config" "example" {
  backend = module.auth_backend.this.path
  tenant_id = var.tenant_id
  client_id = module.service_principal.application.application_id
  client_secret = module.service_principal.password
  resource = module.service_principal.application.web[0].homepage_url
  environment = var.environment
}

