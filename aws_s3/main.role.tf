resource "aws_iam_role" "this" {
  provider = aws.current
  count = var.role ? 1 : 0
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.users_iam_root_arn
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  provider = aws.current
  count = var.role ? 1 : 0
  role = aws_iam_role.this.0.name
  policy_arn = aws_iam_policy.this.arn
}
