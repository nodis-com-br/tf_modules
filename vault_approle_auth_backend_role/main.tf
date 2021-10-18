resource "vault_policy" "this" {
  for_each = var.policy_definitions
  name = "${var.name}-${each.key}"
  policy = each.value
}

resource "vault_approle_auth_backend_role" "this" {
  backend = var.backend.path
  role_name  = var.name
  token_policies = concat(var.policies, [for k, v in vault_policy.this : v.name])
  secret_id_bound_cidrs = var.secret_id_bound_cidrs
}

resource "vault_approle_auth_backend_role_secret_id" "this" {
  backend = var.backend.path
  role_name = vault_approle_auth_backend_role.this.role_name
}