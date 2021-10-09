resource "mongodbatlas_project" "this" {
  name = var.name
  org_id = var.org
}

resource "mongodbatlas_project_ip_access_list" "this" {
  for_each = var.ip_access_list
  project_id = mongodbatlas_project.this.id
  cidr_block = each.value
  comment = each.key
}

resource "vault_database_secret_backend_connection" "this" {
  backend = var.vault_path
  name = var.vault_secret_backend_config_name
  root_rotation_statements = var.root_rotation_statements
  mongodbatlas {
    public_key = var.vault_secret_backend_credentials.public_key
    private_key = var.vault_secret_backend_credentials.private_key
    project_id = mongodbatlas_project.this.id
  }
  lifecycle {
    ignore_changes = [
      allowed_roles,
      mongodbatlas.0.private_key
    ]
  }
}