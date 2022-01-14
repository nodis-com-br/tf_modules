locals {
  aws = {
    policy_arns = {
      admin = "arn:aws:iam::aws:policy/AdministratorAccess"
      ec2_admin = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
      change_password = "arn:aws:iam::aws:policy/IAMUserChangePassword"
    }
    policies = {
      admin = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = "*"
            Resource = "*"
          }
        ]
      })
      rekognition = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Effect = "Allow",
            Action = [
              "rekognition:*"
            ],
            Resource = "*"
          },

        ]
      })
      monitoring = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Effect = "Allow",
            Action = [
              "ec2:DescribeInstances",
              "rds:DescribeDBInstances",
              "rds:ListTagsForResource"
            ],
            Resource = "*"
          },

        ]
      })
      editor = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Sid = "VisualEditor0",
            Effect = "Allow",
            NotAction = [
              "aws-portal:*",
              "budgets:*",
              "cur:*",
              "purchase-orders:*",
              "iam:*"
            ],
            Resource = "*"
          }
        ]
      })
      simple_mail_service = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = "ses:SendRawEmail"
            Resource = "*"
          }
        ]
      })
    }
    vault_kv_path = "secret/aws"
  }
}