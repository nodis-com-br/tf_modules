resource "vault_aws_secret_backend" "this" {
  access_key = var.access_key
  secret_key = var.secret_key
}