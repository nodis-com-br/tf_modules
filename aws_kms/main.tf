resource "aws_kms_key" "this" {
  provider = aws.current
  description = var.name
  deletion_window_in_days = 10
}

module "user" {
  source = "../aws_iam_user"
  count = var.access_key ? 1 : 0
  username = var.username == null ? var.name : var.username
  access_key = true
  policies = {
    this = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Sid = "VaultKMSUnseal"
          Effect = "Allow",
          Action = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:DescribeKey"
          ],
          Resource = ["*"]
        }
      ]
    })
  }
  providers = {
    aws.current = aws.current
  }
}

//resource "aws_iam_user" "this" {
//  provider = aws.current
//  count = var.access_key ? 1 : 0
//  name = var.username == null ? var.name : var.username
//  tags = {}
//}
//
//resource "aws_iam_access_key" "this" {
//  count = var.access_key ? 1 : 0
//  provider = aws.current
//  user = aws_iam_user.this.0.name
//}
//
//resource "aws_iam_user_policy_attachment" "this" {
//  count = var.access_key ? 1 : 0
//  provider = aws.current
//  policy_arn = aws_iam_policy.this.arn
//  user = aws_iam_user.this.0.name
//}
