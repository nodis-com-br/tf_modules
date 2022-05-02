locals {
  console_policies = [
    "view_account_info",
    "manage_own_password",
    "manage_own_access_keys",
//    "manage_own_signed_certificates",
    "manage_own_ssh_public_keys",
//    "manage_own_git_credentials",
    "manage_own_virtual_mfa_device",
    "manage_own_user_mfa",
//    "deny_all_except_listed_if_no_mfa"
  ]
  selected_policies = distinct(concat(var.builtin_policies, var.console ? local.console_policies : []))
  policies = merge(var.policies, {for l in local.selected_policies : l => module.defaults.aws.policies[l]})
  console_policy_arns = []
  selected_builtin_policy_arns = [for l in  distinct(concat(var.builtin_policy_arns, var.console ? local.console_policy_arns : [])) : module.defaults.aws.policy_arns[l]]
}