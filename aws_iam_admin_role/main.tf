resource "aws_iam_role" "this" {
  provider = aws.current
  name = "${var.account}-admin"
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
  role = aws_iam_role.this.id
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_policy" "this" {
  provider = aws.users
  name = "assume-${var.account}-admin-role"
  path = "/"
  description = ""
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sts:AssumeRole"
        ],
        Resource = [
          aws_iam_role.this.arn
        ]
      }
    ]
  })
}
