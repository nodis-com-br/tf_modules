output "policy" {
  value = aws_iam_policy.this
}

output "role" {
  value = var.role ? module.role.0.this : null
  sensitive = true
}