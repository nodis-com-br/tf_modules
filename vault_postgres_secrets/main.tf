resource "random_password" "this" {
  length  = 16
  special = false
}

resource "postgresql_role" "this" {
  provider = postgresql
  name = "${var.role_name_prefix}-${var.database}"
  login = true
  password = random_password.this.result
  create_role = true
  roles = [
    "postgres"
  ]
  search_path = []
}

resource "vault_database_secret_backend_connection" "this" {
  name = var.name
  backend = var.backend_path
  root_rotation_statements = [
    "ALTER ROLE \"${postgresql_role.this.name}\" WITH PASSWORD '{{password}}';"
  ]
  postgresql {
    connection_url = "postgres://{{username}}:{{password}}@${var.host}/${var.database}?sslmode=require"
  }
  data = {
    username = "${postgresql_role.this.name}${var.login_name_suffix}"
    password = postgresql_role.this.password
  }
  allowed_roles = var.allowed_roles
  lifecycle {
    ignore_changes = [
      postgresql
    ]
  }
}

resource "null_resource" "rotate_role_password" {
  triggers = {
    password = vault_database_secret_backend_connection.this.data.password
  }
  provisioner "local-exec" {
    command = "VAULT_TOKEN=${data.vault_generic_secret.token.data.id} vault write -force ${var.backend_path}/rotate-root/${vault_database_secret_backend_connection.this.name}"
  }
  depends_on = [
    vault_database_secret_backend_connection.this
  ]
}