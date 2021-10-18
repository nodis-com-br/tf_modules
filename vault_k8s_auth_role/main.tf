resource "vault_policy" "this" {
  for_each = token_policy_definitions
  name = "${var.name}-${each.key}"
  policy = each.value
}


resource "vault_kubernetes_auth_backend_role" "this" {
  backend = var.backend
  role_name = var.name
  audience = var.audience
  bound_service_account_names = var.bound_service_account_names
  bound_service_account_namespaces = var.bound_service_account_namespaces
  token_ttl = var.token_ttl
  token_max_ttl = var.token_max_ttl
  token_policies = concat(var.policies, [for k, v in vault_policy.this : v.name])
}