locals {
  selected_builtin_roles = { for r in var.builtin_roles : r => module.defaults.azure.roles[r] }
  roles = merge(var.roles, local.selected_builtin_roles)
  selected_builtin_resource_accesses = {for r in var.builtin_resource_accesses : r => module.defaults.azure.resource_accesses[r] }
  resource_accesses = merge(var.resource_accesses, local.selected_builtin_resource_accesses)
}