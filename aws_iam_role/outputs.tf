output "this" {
  value = aws_iam_role.this
}

output "vault_role" {
  value = var.vault_role != null ? module.vault_role[0].this : null
  sensitive = true
}