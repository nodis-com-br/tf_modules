resource "aws_kms_key" "this" {
  provider = aws.current
  description = var.name
  deletion_window_in_days = 10
}

resource "aws_iam_policy" "this" {
  provider = aws.current
  policy = jsonencode({
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
