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
  providers = {
    aws.current = aws.current
  }
}