module "service_account" {
  source = "../gcp_service_account"
  account_id = "vault-sa"
  project = var.gcp_project
  roles = [
    "roles/editor"
  ]
}

resource "vault_gcp_secret_backend" "this" {
  credentials = base64decode(module.service_account.key.private_key)
}