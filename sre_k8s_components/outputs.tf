output "kubernetes_secret_backend" {
  value = length(module.vault_secrets_backend) > 0 ? module.vault_secrets_backend[0].this : null
}

output "kubernetes_auth_backend" {
  value = length(module.vault_auth_backend) > 0 ? module.vault_auth_backend[0].this : null
}