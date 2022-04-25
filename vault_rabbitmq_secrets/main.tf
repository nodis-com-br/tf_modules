resource "random_password" "this" {
  length  = 16
  special = false
}

resource "rabbitmq_user" "this" {
  provider = rabbitmq
  name = var.username
  password = random_password.this.result
  tags = var.user_tags
}


resource "vault_rabbitmq_secret_backend" "this" {
  path = var.path
  connection_uri = var.connection_uri
  username = rabbitmq_user.this.name
  password = rabbitmq_user.this.password
  default_lease_ttl_seconds = var.default_lease_ttl_seconds
  max_lease_ttl_seconds = var.max_lease_ttl_seconds
}