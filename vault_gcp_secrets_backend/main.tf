module "service_account" {
  source = "../gcp_service_account"
  account_id = "vault"
  project = var.gcp_project
  roles = [
    'role/editor'
  ]
}

resource "vault_gcp_secret_backend" "this" {
  credentials = base64decode(module.service_account.key.private_key)
}