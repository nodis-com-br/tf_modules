resource "vault_database_secret_backend_role" "this" {
  backend = var.backend.path
  name = var.name
  db_name = var.db_name
  creation_statements = var.creation_statements
}