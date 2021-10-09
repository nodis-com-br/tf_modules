resource "random_password" "vault" {
  count = var.vault_path == null ? 0 : 1
  length  = 16
  special = false
  keepers = {
    version = var.vault_password_version
  }
}

resource "postgresql_role" "vault" {
  count = var.vault_path == null ? 0 : 1
  name = var.vault_postgres_role_name
  login = true
  password =  random_password.vault.0.result
  create_role = true
  roles = [
    "postgres"
  ]
  search_path = []
}

resource "vault_database_secret_backend_connection" "this" {
  count = var.vault_path == null ? 0 : 1
  backend = var.vault_path
  name = local.short_name
  root_rotation_statements = [
    "ALTER ROLE ${var.vault_postgres_role_name} WITH PASSWORD '{{password}}';"
  ]
  postgresql {
    connection_url = "postgres://{{username}}:{{password}}@${aws_route53_record.this.0.fqdn}/postgres?sslmode=require"
  }
  data = {
    username = "${var.vault_postgres_role_name}@${local.name}"
    password = random_password.vault.0.result
  }
  lifecycle {
    ignore_changes = [
      allowed_roles
    ]
  }
}

resource "null_resource" "vault-root-rotate" {
  count = var.vault_path == null ? 0 : 1
  triggers = {
    password = vault_database_secret_backend_connection.this.0.data.password
  }
  provisioner "local-exec" {
    command = "VAULT_TOKEN=${data.vault_generic_secret.token.data.id} vault write -force ${var.vault_path}/rotate-root/${local.short_name}"
  }
  depends_on = [
    vault_database_secret_backend_connection.this.0
  ]
}