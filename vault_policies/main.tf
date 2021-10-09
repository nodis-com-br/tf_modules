resource "vault_policy" "this" {
  for_each = toset(local.policy_files)
  name = each.key
  policy = data.local_file.policy[each.key].content
}