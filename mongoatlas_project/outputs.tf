output "this" {
  value = mongodbatlas_project.this
}

output "credentials" {
  value = {
    username = mongodbatlas_database_user.this.username
    password = mongodbatlas_database_user.this.password
  }
}

output "vault_secrets_backend" {
  value = module.vault_secrets_backend.this
}