resource "vault_policy" "this" {
  name = "${var.backend}_${var.name}"
  policy = join("\n\n", var.policy_definitions)
}


resource "vault_kubernetes_auth_backend_role" "this" {
  backend = var.backend
  role_name = var.name
  audience = var.audience
  bound_service_account_names = var.bound_service_account_names
  bound_service_account_namespaces = var.bound_service_account_namespaces
  token_ttl = var.token_ttl
  token_max_ttl = var.token_max_ttl
  token_policies = [vault_policy.this.name]
}