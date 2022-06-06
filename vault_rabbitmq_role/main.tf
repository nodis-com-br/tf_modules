resource "vault_rabbitmq_secret_backend_role" "this" {
  name = var.name
  backend = try(var.backend.path, var.backend)
  tags = var.tags
  dynamic "vhost" {
    for_each = {for i, v in var.vhosts : i => v}
    content {
      host = vhost.value["host"]
      configure = vhost.value["configure"]
      read = vhost.value["read"]
      write = vhost.value["write"]
    }
  }
}