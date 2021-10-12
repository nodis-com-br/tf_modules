locals {
  builtin_policies = {
    admin = 'arn:aws:iam::aws:policy/AdministratorAccess'
    ec2_admin = 'arn:aws:iam::aws:policy/AmazonEC2FullAccess'
  }
  selected_builtin_policy_arns = {for l in var.builtin_policies : l => local.builtin_policies[l]}
  policy_arns = concat(var.policy_arns, local.selected_builtin_policy_arns)
}