output "this" {
  value = aws_s3_bucket.this
}

output "policy" {
  value = module.policy.this
}

output "role" {
  value = var.role ? module.role[0].this : null
  sensitive = true
}

output "vault_role" {
  value = var.vault_role != null ? module.role[0].vault_role : null
  sensitive = true
}
