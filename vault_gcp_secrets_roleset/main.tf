resource "vault_gcp_secret_roleset" "this" {
  backend = var.backend.path
  roleset = var.name
  secret_type  = var.secret_type
  project = var.project.project_id
  token_scopes = var.secret_type == "access_token" ? var.token_scopes : null

  binding {
    resource = "//cloudresourcemanager.googleapis.com/projects/${var.project.project_id}"
    roles = var.roles
  }
}