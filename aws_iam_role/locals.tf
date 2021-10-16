locals {
  selected_builtin_policy_arns = [for l in var.builtin_policies : module.defaults.aws.policy_arns[l]]
  policy_arns = concat(var.policy_arns, local.selected_builtin_policy_arns)
}