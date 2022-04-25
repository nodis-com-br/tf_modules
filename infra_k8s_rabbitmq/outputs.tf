output "credentials" {
  value = {
    uri = "${var.management_schema}://${var.name}.${var.subdomain}:${var.management_port}"
    username = try(data.kubernetes_secret.default_user.data.username, null)
    password = try(data.kubernetes_secret.default_user.data.password, null)
  }
}