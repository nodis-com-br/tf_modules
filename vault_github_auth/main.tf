resource "vault_github_auth_backend" "this" {
  organization = var.organization
  path = var.path
  token_bound_cidrs = []
  token_policies = []
  tune {
    default_lease_ttl = var.default_lease_ttl
    max_lease_ttl = var.max_lease_ttl
    token_type = "default-service"
  }
}
