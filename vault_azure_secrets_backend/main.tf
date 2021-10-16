module "service_principal" {
  source = "../azure_service_principal"
  name = "vault"
  create_password = true
  builtin_resource_accesses = ["windows_graph_admin"]
  builtin_roles = ["owner"]
}

resource "vault_azure_secret_backend" "this" {
  subscription_id = data.azurerm_client_config.current.subscription_id
  tenant_id = data.azurerm_client_config.current.tenant_id
  environment = var.environment
  client_id = module.service_principal.application.application_id
  client_secret = module.service_principal.password.value
}

