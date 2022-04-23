output "kubernetes_secret_backend" {
  value = module.vault_secrets_backend.this
}

output "kubernetes_auth_backend" {
  value = module.vault_auth_backend != null ? module.vault_auth_backend[0].this : null
}

output "rabbitmq_secrets_backend" {
  value = vault_rabbitmq_secret_backend.this != null ? vault_rabbitmq_secret_backend.this[0] : null
}