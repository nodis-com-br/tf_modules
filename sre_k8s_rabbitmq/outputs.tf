output "this" {
  value = module.rabbitmq.this
}

output "credentials" {
  value = {
    uri = "${var.management_schema}://${var.domain}:${var.management_port}"
    username = var.vault_secret_path != null ? "admin" : try(data.kubernetes_secret.default_user.data.username, null)
    password = var.vault_secret_path != null ? random_password.this[0].result : try(data.kubernetes_secret.default_user.data.password, null)
  }
}