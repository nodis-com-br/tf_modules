output "credentials" {
  value = {
    uri = "${var.management_schema}://${var.name}.${var.subdomain}:${var.management_port}"
    username = data.kubernetes_secret.default_user[0].data.username
    password = data.kubernetes_secret.default_user[0].data.password
  }
}