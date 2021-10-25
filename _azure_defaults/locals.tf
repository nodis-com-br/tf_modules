locals {
  azure = {
    roles = {
      contributor =  {
        definition_name = "Contributor"
        scope = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
      }
      owner =  {
        definition_name = "Owner"
        scope = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
      }
    }
    resource_accesses = {
      aad_admin = {
        resource_app_id = "00000002-0000-0000-c000-000000000000"
        resource_access = {
          user_read = {
            type = "Scope"
            id = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
            scope = "User.Read"
          }
          application_readwrite_all = {
            type = "Role"
            id = "1cda74f2-2616-4834-b122-5cb1b07f8a59"
            scope = "Application.ReadWrite.All"
          }
          directory_readwrite_all = {
            type = "Role"
            id = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"
            scope = "Directory.ReadWrite.All"
          }
        }
      }
      windows_graph_admin = {
        resource_app_id = "00000003-0000-0000-c000-000000000000"
        resource_access = {
          user_read = {
            type = "Scope"
            id = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
            scope = "User.Read"
          }
          application_readwrite_all = {
            type = "Role"
            id = "1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9"
            scope = "Application.ReadWrite.All"
          }
          directory_readwrite_all = {
            type = "Role"
            id = "19dbc75e-c2e2-444c-a770-ec69d8559fc7"
            scope = "Directory.ReadWrite.All"
          }
        }
      }
    }
    vault_kv_path = "secret/azure"
  }
}