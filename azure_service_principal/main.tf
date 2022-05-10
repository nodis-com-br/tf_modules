resource "azuread_application" "this" {
  display_name = var.name
  web {
    homepage_url = var.homepage_url
    implicit_grant {
      id_token_issuance_enabled = false
      access_token_issuance_enabled = false
    }
  }
  dynamic required_resource_access {
    for_each = var.resource_accesses
    content {
      resource_app_id = required_resource_access.value.resource_app_id
      dynamic resource_access {
        for_each = required_resource_access.value.resource_access
        content {
          id = resource_access.value.id
          type = resource_access.value.type
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [
      api
    ]
  }
}

resource "azuread_service_principal" "this" {
  application_id = azuread_application.this.application_id
}

resource "azuread_service_principal_password" "this" {
  count = var.create_password ? 1 : 0
  service_principal_id = azuread_service_principal.this.id
  value = null
  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}

resource "azuread_group_member" "this" {
  for_each = toset(var.group_ids)
  group_object_id  = each.value
  member_object_id = azuread_service_principal.this.object_id
}

resource "azurerm_role_assignment" "this" {
  for_each = var.roles
  scope = each.value.scope
  role_definition_name = each.value.definition_name
  principal_id = azuread_service_principal.this.object_id
}

module "vault_role" {
  source = "../vault_azure_secrets_role"
  count = var.vault_role != null ? 1 : 0
  name = var.vault_role
  ttl = var.vault_ttl
  max_ttl = var.vault_max_ttl
  backend = var.vault_secrets_backend
  application_object_id = azuread_application.this.object_id
}
