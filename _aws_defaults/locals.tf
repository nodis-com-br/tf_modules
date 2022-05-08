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
      simple_email_service = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = "ses:SendRawEmail"
            Resource = "*"
          }
        ]
      })
      view_account_info = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Sid = "AllowViewAccountInfo"
            Effect = "Allow"
            Action = [
              "iam:GetAccountPasswordPolicy",
              "iam:ListVirtualMFADevices"
            ]
            Resource = "*"
          }
        ]
      })
      manage_own_password = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Sid = "AllowManageOwnPasswords"
            Effect = "Allow"
            Action = [
              "iam:ChangePassword",
              "iam:GetUser"
            ]
            Resource = "arn:aws:iam::*:user/${var.username}"
          }
        ]
      })
      manage_own_access_keys = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Sid = "AllowManageOwnAccessKeys"
            Effect = "Allow"
            Action = [
              "iam:CreateAccessKey",
              "iam:DeleteAccessKey",
              "iam:ListAccessKeys",
              "iam:UpdateAccessKey"
            ]
            Resource = "arn:aws:iam::*:user/${var.username}"
          }
        ]
      })
      manage_own_signed_certificates = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Sid = "AllowManageOwnSigningCertificates"
            Effect = "Allow"
            Action = [
              "iam:DeleteSigningCertificate",
              "iam:ListSigningCertificates",
              "iam:UpdateSigningCertificate",
              "iam:UploadSigningCertificate"
            ]
            Resource = "arn:aws:iam::*:user/${var.username}"
          }
        ]
      })
      manage_own_ssh_public_keys = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Sid = "AllowManageOwnSSHPublicKeys"
            Effect = "Allow"
            Action = [
              "iam:DeleteSSHPublicKey",
              "iam:GetSSHPublicKey",
              "iam:ListSSHPublicKeys",
              "iam:UpdateSSHPublicKey",
              "iam:UploadSSHPublicKey"
            ]
            Resource = "arn:aws:iam::*:user/${var.username}"
          }
        ]
      })
      manage_own_git_credentials = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Sid = "AllowManageOwnGitCredentials"
            Effect = "Allow"
            Action = [
              "iam:CreateServiceSpecificCredential",
              "iam:DeleteServiceSpecificCredential",
              "iam:ListServiceSpecificCredentials",
              "iam:ResetServiceSpecificCredential",
              "iam:UpdateServiceSpecificCredential"
            ]
            Resource = "arn:aws:iam::*:user/${var.username}"
          }
        ]
      })
      manage_own_virtual_mfa_device = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Sid = "AllowManageOwnVirtualMFADevice"
            Effect = "Allow"
            Action = [
              "iam:CreateVirtualMFADevice",
              "iam:DeleteVirtualMFADevice"
            ]
            Resource = "arn:aws:iam::*:mfa/${var.username}"
          }
        ]
      })
      manage_own_user_mfa = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Sid = "AllowManageOwnUserMFA"
            Effect = "Allow"
            Action = [
              "iam:DeactivateMFADevice",
              "iam:EnableMFADevice",
              "iam:ListMFADevices",
              "iam:ResyncMFADevice"
            ]
            Resource = "arn:aws:iam::*:user/${var.username}"
          }
        ]
      })
      deny_all_except_listed_if_no_mfa = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Sid = "DenyAllExceptListedIfNoMFA"
            Effect = "Deny"
            NotAction = [
              "iam:CreateVirtualMFADevice",
              "iam:EnableMFADevice",
              "iam:GetUser",
              "iam:ListMFADevices",
              "iam:ListVirtualMFADevices",
              "iam:ResyncMFADevice",
              "sts:GetSessionToken"
            ]
            Resource = "*"
            Condition = {
              BoolIfExists = {
                "aws:MultiFactorAuthPresent" = "false"
              }
            }
          }
        ]
      })
    }
  }
}