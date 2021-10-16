locals {
  builtin_roles = {
    contributor =  {
      definition_name = "Contributor"
      scope = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
    }
  }
  builtin_resource_accesses = {
    aad_admin = {
      resource_app_id =  "00000002-0000-0000-c000-000000000000"
      resource_access = {
        1 = {
          type = "Scope"
          id = "311a71cc-e848-46a1-bdf8-97ff7156d8e6" # user_read
        }
        2 = {
          type = "Role"
          id = "1cda74f2-2616-4834-b122-5cb1b07f8a59" # application_readwrite_all
        }
        3 = {
          type = "Role"
          id = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175" # directory_readwrite_all
        }
      }
    }
  }
  selected_builtin_roles = { for r in var.builtin_roles : r => local.builtin_roles[r] }
  roles = merge(var.roles, local.selected_builtin_roles)
  selected_builtin_resource_accesses = {for r in var.builtin_resource_accesses : r => local.builtin_resource_accesses[r] }
  resource_accesses = merge(var.resource_accesses, local.selected_builtin_resource_accesses)
}