output "policies" {
  value = vault_policy.this
}

output "policy_files" {
  value = local.policy_files
}