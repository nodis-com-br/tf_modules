resource "vault_database_secret_backend_connection" "this" {
  name = var.name
  backend = try(var.backend.path, var.backend)
  mongodbatlas {
    private_key = var.private_key
    project_id = var.project_id
    public_key = var.public_key
  }
  allowed_roles = var.allowed_roles
  lifecycle {
    ignore_changes = [
      mongodbatlas
    ]
  }
}