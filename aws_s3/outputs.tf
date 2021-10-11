output "policy" {
  value = aws_iam_policy.this
}

output "access_key" {
  value = var.access_key ? aws_iam_access_key.this.0 : null
  sensitive = true
}

output "role" {
  value = var.role ? aws_iam_role.this.0 : null
  sensitive = true
}