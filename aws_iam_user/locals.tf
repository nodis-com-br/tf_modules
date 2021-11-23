locals {
  policies = {
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
          Resource = "arn:aws:iam::*:user/${aws_iam_user.this.name}"
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
          Resource = "arn:aws:iam::*:user/${aws_iam_user.this.name}"
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
          Resource = "arn:aws:iam::*:user/${aws_iam_user.this.name}"
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
          Resource = "arn:aws:iam::*:user/${aws_iam_user.this.name}"
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
          Resource = "arn:aws:iam::*:user/${aws_iam_user.this.name}"
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
          Resource = "arn:aws:iam::*:mfa/${aws_iam_user.this.name}"
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
          Resource = "arn:aws:iam::*:user/${aws_iam_user.this.name}"
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
  selected_policies = {for l in distinct(concat(var.builtin_policies, var.console ? local.console_policies : [])) : l => local.policies[l]}
  all_policies = merge(var.policies, local.selected_policies)
  console_policy_arns = []
  selected_builtin_policy_arns = [for l in  distinct(concat(var.builtin_policy_arns, var.console ? local.console_policy_arns : [])) : module.defaults.aws.policy_arns[l]]
  policy_arns = concat(var.policy_arns, local.selected_builtin_policy_arns)
}