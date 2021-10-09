output "name" {
  value = aws_iam_user.this.name
}

output "arn" {
  value = aws_iam_user.this.arn
}

output "access_key" {
  value = var.access_key ? aws_iam_access_key.this.0 : null
  sensitive = true
}

output "encrypted_password" {
  value = var.console ? aws_iam_user_login_profile.this.0.encrypted_password : null
}