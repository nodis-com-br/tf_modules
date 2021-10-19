output "policy" {
  value = aws_iam_policy.this
}

output "role" {
  value = var.role ? module.role.0.this : null
  sensitive = true
}

output "access_key" {
  value = var.access_key ? module.user.access_key : null
  sensitive = true
}