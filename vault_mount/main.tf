resource "vault_mount" "this" {
  path = var.path
  type = var.type
  default_lease_ttl_seconds = var.default_lease_ttl_seconds
  max_lease_ttl_seconds = var.max_lease_ttl_seconds
}
