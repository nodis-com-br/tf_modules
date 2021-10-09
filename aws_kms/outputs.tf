output "policy" {
  value = aws_iam_policy.this
}

output "access_key" {
  value = var.access_key ? aws_iam_access_key.this.0 : null
  sensitive = true
}

output "kms_key" {
  value = aws_kms_key.this
  sensitive = true
}