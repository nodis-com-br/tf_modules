output "this" {
  value = vault_rabbitmq_secret_backend_role.this
  sensitive = true
}

output "role_path" {
  value = "${vault_rabbitmq_secret_backend_role.this.backend}/creds/${vault_rabbitmq_secret_backend_role.this.name}"
}