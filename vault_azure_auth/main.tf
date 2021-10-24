module "service_principal" {
  source = "../azure_service_principal"
  name = var.service_principal_name
  homepage_url = var.vault_addr
  create_password = true
  builtin_resource_accesses = ["aad_admin"]
}

resource "vault_auth_backend" "this" {
  type = "azure"
  path = var.path
}

resource "vault_azure_auth_backend_config" "example" {
  backend = vault_auth_backend.this.path
  tenant_id = data.azurerm_client_config.current.tenant_id
  client_id = module.service_principal.application.application_id
  client_secret = module.service_principal.password.value
  resource = module.service_principal.application.web.0.homepage_url
  environment = var.environment
}