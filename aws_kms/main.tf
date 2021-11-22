resource "aws_kms_key" "this" {
  provider = aws.current
  description = var.name
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation = var.enable_key_rotation
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
