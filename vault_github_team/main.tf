resource "vault_policy" "this" {
  for_each = var.policy_definitions
  name = "${var.name}-${each.key}"
  policy = each.value
}

resource "vault_github_team" "this" {
  team = var.name
  backend  = var.backend.id
  policies = concat(var.policies, [for k, v in vault_policy.this : v.name])
}

