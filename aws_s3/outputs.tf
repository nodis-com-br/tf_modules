output "policy" {
  value = var.policy ? aws_iam_policy.this.0 : null
}

output "role" {
  value = var.role ? module.role.0.this : null
  sensitive = true
}

output "access_key" {
  value = var.access_key ? module.user.0.access_key : null
  sensitive = true
}