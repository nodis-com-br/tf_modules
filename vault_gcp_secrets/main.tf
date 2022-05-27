module "service_account" {
  source = "../gcp_service_account"
  account_id = "vault-sa"
  account_key = true
  project = var.project.project_id
  roles = [
    "roles/owner",
    "roles/iam.securityAdmin"
  ]
}

resource "vault_gcp_secret_backend" "this" {
  credentials = base64decode(module.service_account.key["private_key"])
  path = var.path
  default_lease_ttl_seconds = var.default_lease_ttl_seconds
  max_lease_ttl_seconds = var.max_lease_ttl_seconds
}

