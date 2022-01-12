module "aws_user" {
  source = "../aws_iam_user"
  username = "vault"
  access_key = true
  policies = {
    vault = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "iam:AttachUserPolicy",
            "iam:CreateAccessKey",
            "iam:CreateUser",
            "iam:DeleteAccessKey",
            "iam:DeleteUser",
            "iam:DeleteUserPolicy",
            "iam:DetachUserPolicy",
            "iam:ListAccessKeys",
            "iam:ListAttachedUserPolicies",
            "iam:ListGroupsForUser",
            "iam:ListUserPolicies",
            "iam:PutUserPolicy",
            "iam:AddUserToGroup",
            "iam:RemoveUserFromGroup"
          ]
          Resource = ["arn:aws:iam::*:user/vault-*"]
        },
        {
          Effect = "Allow"
          Action = [
            "sts:AssumeRole"
          ]
          Resource = ["arn:aws:iam::*:role/*"]
        }
      ]
    })
  }
  providers = {
    aws.current = aws.users
  }
}

resource "vault_aws_secret_backend" "this" {
  path = var.path
  access_key = module.aws_user.access_key.id
  secret_key = module.aws_user.access_key.secret
  default_lease_ttl_seconds = var.default_lease_ttl_seconds
  max_lease_ttl_seconds = var.max_lease_ttl_seconds
}