locals {
  selected_builtin_policy_arns = [for l in var.builtin_policy_arns : module.defaults.aws.policy_arns[l]]
  policy_arns = concat(var.policy_arns, local.selected_builtin_policy_arns)
  assume_role_policies = {
    iam_role = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Principal = {
            AWS = var.owner_arn
          }
          Effect = "Allow"
        }
      ]
    })
    ec2_instance = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          Effect = "Allow"
          Sid = ""
        }
      ]
    })
  }
}