locals {
  builtin_policies = {
    manage_access_keys = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid = "ManageOwnAccessKeys"
          Effect = "Allow"
          Action = [
            "iam:CreateAccessKey",
            "iam:DeleteAccessKey",
            "iam:GetAccessKeyLastUsed",
            "iam:GetUser",
            "iam:ListAccessKeys",
            "iam:UpdateAccessKey"
          ]
          Resource = "arn:aws:iam::*:user/${aws_iam_user.this.name}"
        }
      ]
    })
  }
  console_policies = [
    "manage_access_keys"
  ]
  selected_builtin_policies = {for l in distinct(concat(var.builtin_policies, var.console ? local.console_policies : [])) : l => local.builtin_policies[l]}
  policies = merge(var.policies, local.selected_builtin_policies)
  console_policy_arns = [
    "change_password"
  ]
  selected_builtin_policy_arns = [for l in  distinct(concat(var.builtin_policy_arns, var.console ? local.console_policy_arns : [])) : module.defaults.aws.policy_arns[l]]
  policy_arns = concat(var.policy_arns, local.selected_builtin_policy_arns)
}