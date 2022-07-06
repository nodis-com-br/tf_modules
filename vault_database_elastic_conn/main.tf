resource "random_password" "this" {
  length  = 16
  special = false
}

resource "elasticsearch_xpack_role" "this" {
  provider = elasticsearch
  role_name = "${var.role_name_prefix}-${var.name}"
  cluster = ["manage_security"]
}

resource "elasticsearch_xpack_user" "this" {
  provider = elasticsearch
  username = "${var.role_name_prefix}-${var.name}"
  password = random_password.this.result
  roles = [elasticsearch_xpack_role.this.role_name]
}

resource "vault_database_secret_backend_connection" "this" {
  name = elasticsearch_xpack_user.this.username
  backend = try(var.backend.path, var.backend)
  elasticsearch {
    url = var.elasticsearch_url
    username = elasticsearch_xpack_user.this.username
    password = random_password.this.result
  }
  allowed_roles = var.allowed_roles
}

resource "null_resource" "rotate_role_password" {
  triggers = {
    password = random_password.this.result
  }
  provisioner "local-exec" {
    command = "VAULT_TOKEN=${var.vault_token} vault write -force ${vault_database_secret_backend_connection.this.backend}/rotate-root/${vault_database_secret_backend_connection.this.name}"
  }
  depends_on = [
    vault_database_secret_backend_connection.this
  ]
}