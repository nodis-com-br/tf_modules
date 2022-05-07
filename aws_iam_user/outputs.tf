output "name" {
  value = aws_iam_user.this.name
}

output "arn" {
  value = aws_iam_user.this.arn
}

output "access_key_id" {
  value = try(aws_iam_access_key.this[0].id, null)
  sensitive = true
}

output "secret_access_key" {
  value = try(aws_iam_access_key.this[0].secret, null)
  sensitive = true
}

output "ses_secret_access_key" {
  value = try(aws_iam_access_key.this[0].ses_smtp_password_v4, null)
  sensitive = true
}

output "encrypted_password" {
  value = var.console ? aws_iam_user_login_profile.this.0.encrypted_password : null
}