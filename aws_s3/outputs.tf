output "policy" {
  value = aws_iam_policy.this
}

output "role" {
  value = var.role ? module.role.this.0 : null
  sensitive = true
}

output "access_key" {
  value = var.access_key ? aws_iam_access_key.this.0 : null
  sensitive = true
}
