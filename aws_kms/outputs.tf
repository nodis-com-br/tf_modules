output "kms_key" {
  value = aws_kms_key.this
  sensitive = true
}

output "access_key_id" {
  value = try(module.user[0].access_key_id, null)
}

output "secret_access_key" {
  value = try(module.user[0].secret_access_key, null)
  sensitive = true
}
