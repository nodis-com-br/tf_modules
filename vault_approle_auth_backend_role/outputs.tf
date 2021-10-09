output "role_id" {
  sensitive = true
  value = vault_approle_auth_backend_role.this.role_id
}

output "secret_id" {
  sensitive = true
  value = vault_approle_auth_backend_role_secret_id.this.secret_id
}