resource "vault_rabbitmq_secret_backend" "this" {
  connection_uri = var.connection_uri
  username = var.username
  password = var.password
  default_lease_ttl_seconds = var.default_lease_ttl_seconds
  max_lease_ttl_seconds = var.max_lease_ttl_seconds
}