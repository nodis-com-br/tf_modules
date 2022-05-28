output "this" {
  value = module.rabbitmq.this
}

output "credentials" {
  value = {
    endpoint = "${var.management_schema}://${var.domain}:${var.management_port}"
    username = try(data.kubernetes_secret.default_user.data.username, random_string.this[0].result, null)
    password = try(data.kubernetes_secret.default_user.data.password, random_password.this[0].result, null)
  }
}