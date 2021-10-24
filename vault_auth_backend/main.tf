resource "vault_auth_backend" "this" {
  type = var.type
  path = var.path
}