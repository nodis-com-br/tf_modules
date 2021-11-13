resource "postgresql_role" "this" {
  name = "${var.role_name_prefix}-${var.database}"
  login = true
  password =  var.role_initial_password
  create_role = true
  roles = [
    "postgres"
  ]
  search_path = []
}

resource "vault_database_secret_backend_connection" "this" {
  backend = var.backend_path
  name = var.name
  root_rotation_statements = [
    "ALTER ROLE \"${postgresql_role.this.name}\" WITH PASSWORD '{{password}}';"
  ]
  postgresql {
    connection_url = "postgres://{{username}}:{{password}}@${var.instace_addr}/${var.database}?sslmode=require"
  }
  data = {
    username = var.instace_name == null ? postgresql_role.this.name : "${postgresql_role.this.name}@${var.instace_name}"
    password = var.role_initial_password
  }
  lifecycle {
    ignore_changes = [
      allowed_roles
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