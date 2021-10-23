output "kms_key" {
  value = aws_kms_key.this
  sensitive = true
}

output "access_key" {
  value = var.access_key ? module.user.0.access_key : null
  sensitive = true
}
