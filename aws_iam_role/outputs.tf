output "this" {
  value = aws_iam_role.this
}

output "vault_role_name" {
  value = var.vault_role != null ? module.vault_role[0].this.name : null
  sensitive = true
}

output "vault_role_path" {
  value = var.vault_role != null ? module.vault_role[0].role_path : null
  sensitive = true
}