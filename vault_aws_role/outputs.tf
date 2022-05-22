output "this" {
  value = vault_aws_secret_backend_role.this
  sensitive = true
}

output "role_path" {
  value = "${vault_aws_secret_backend_role.this.backend}/${vault_aws_secret_backend_role.this.credential_type == "assumed_role" ? "sts" : "creds"}/${vault_aws_secret_backend_role.this.name}"
}