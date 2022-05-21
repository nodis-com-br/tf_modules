output "this" {
  value = aws_s3_bucket.this
}

output "policy_arn" {
  value = try(module.policy[0].this.arn, null)
}

output "role" {
  value = var.role ? module.role[0].this : null
  sensitive = true
}

output "vault_role_name" {
  value = var.vault_role != null ? module.role[0].vault_role_name : null
  sensitive = true
}

output "vault_sts_role_path" {
  value = var.vault_role != null ? module.role[0].vault_sts_role_path : null
  sensitive = true
}
