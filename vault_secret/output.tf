output "this" {
  value = vault_generic_secret.this
}

output "data_path" {
  value = "${try(var.backend.path, var.backend)}data/${var.path}"
}