resource "vault_azure_secret_backend_role" "this" {
  backend = try(var.backend.path, var.backend)
  role = var.name
  ttl = var.ttl
  max_ttl = var.max_ttl
  application_object_id = var.application_object_id
  dynamic "azure_groups" {
    for_each = var.groups
    content {
      group_name = azure_groups.value.group_name
    }
  }
  dynamic "azure_roles" {
    for_each = var.roles
    content {
      role_name = azure_roles.value.role_name
      scope =  azure_roles.value.scope
    }
  }
}