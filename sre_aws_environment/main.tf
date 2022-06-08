module "iam_password_policy" {
  source = "../aws_iam_account_password_policy"
  providers = {
    aws.current = aws.current
  }
}

module "cloudtrail" {
  source = "../aws_cloudtrail"
  name = "audit_logs"
  bucket_name = "${var.bucket_name_prefix}-${var.name}-audit-logs"
  account_id = var.account_id
  providers = {
    aws.current = aws.current
  }
}

module "developer_role" {
  source = "../aws_iam_role"
  count = var.developer_role ? 1 : 0
  assume_role_principal = {AWS = var.role_owner_arn}
  policy_arns = var.developer_role_policy_arns
  providers = {
    aws.current = aws.current
  }
}