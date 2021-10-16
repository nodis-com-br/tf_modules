locals {
  builtin_policy_arns = {
    admin = "arn:aws:iam::aws:policy/AdministratorAccess"
    ec2_admin = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
    change_password = "arn:aws:iam::aws:policy/IAMUserChangePassword"
  }
  default_policy_arns = [
    'change_password'
  ]
  selected_builtin_policy_arns = {for l in distinct(concat(var.builtin_policy_arns, local.default_policy_arns)) : l => local.builtin_policy_arns[l]}
  policy_arns = merge(var.policy_arns, local.selected_builtin_policy_arns)
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
  default_policies = [
    'manage_access_keys'
  ]
  selected_builtin_policies = {for l in distinct(concat(var.builtin_policies, local.default_policies)) : l => local.builtin_policies[l]}
  policies = merge(var.policy_arns, local.selected_builtin_policies)

}