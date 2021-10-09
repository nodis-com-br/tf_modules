resource "azuread_application" "this" {
  display_name = var.name
  name = null
}

resource "azuread_service_principal" "this" {
  application_id = azuread_application.this.application_id
  tags = []
}

resource "azuread_service_principal_password" "this" {
  service_principal_id = azuread_service_principal.this.id
  end_date = timeadd(timestamp(), "87600h")
  value = null
  lifecycle {
    ignore_changes = [end_date]
  }
}

resource "azurerm_key_vault" "this" {
  name = "${var.rg.name}-${var.name}"
  location = var.rg.location
  resource_group_name = var.rg.name
  tenant_id = var.tenant_id
  enabled_for_deployment = true
  sku_name = "standard"
  access_policy {
    tenant_id = var.tenant_id
    object_id = azuread_service_principal.this.object_id
    key_permissions = [
      "get",
      "wrapKey",
      "unwrapKey",
    ]
  }
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [
      "get",
      "list",
      "create",
      "delete",
      "update",
    ]
  }
  network_acls {
    default_action = "Allow"
    bypass = "AzureServices"
  }
}

resource "azurerm_key_vault_key" "this" {
  name = "${var.rg.name}-${var.name}"
  key_vault_id = azurerm_key_vault.this.id
  key_type = "RSA"
  key_size = 2048
  key_opts = [
    "wrapKey",
    "unwrapKey",
  ]
}
