resource "vault_policy" "this" {
  name = "approle_${var.name}"
  policy = join("\n\n", var.policy_definitions)
}

resource "vault_approle_auth_backend_role" "this" {
  backend = var.backend.path
  role_name  = var.name
  token_policies = [vault_policy.this.name]
  secret_id_bound_cidrs = var.secret_id_bound_cidrs
}

resource "vault_approle_auth_backend_role_secret_id" "this" {
  backend = var.backend.path
  role_name = vault_approle_auth_backend_role.this.role_name
}