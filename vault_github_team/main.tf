resource "vault_policy" "this" {
  name = "github_${var.name}"
  policy = join("\n\n", var.policy_definitions)
}

resource "vault_github_team" "this" {
  team = var.name
  backend  = var.backend.id
  policies = [vault_policy.this.name]
}

