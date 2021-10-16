locals {
  aws = {
    policy_arns = {
      admin = "arn:aws:iam::aws:policy/AdministratorAccess"
      ec2_admin = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
      change_password = "arn:aws:iam::aws:policy/IAMUserChangePassword"
    }
  }
  azure = {}
}