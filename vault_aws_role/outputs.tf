output "this" {
  value = vault_aws_secret_backend_role.this
  sensitive = true
}

output "sts_role_path" {
  value = "${vault_aws_secret_backend_role.this.backend}/sts/${vault_aws_secret_backend_role.this.name}"
}