resource "aws_iam_user" "this" {
  provider = aws.current
  name = var.username
  path = "/"
}

resource "aws_iam_access_key" "this" {
  provider = aws.current
  count = var.access_key ? 1 : 0
  user = aws_iam_user.this.name
}

resource "aws_iam_user_login_profile" "this" {
  provider = aws.current
  count = var.console ? 1 : 0
  user    = aws_iam_user.this.name
  pgp_key = var.pgp_key
  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
}

resource "aws_iam_user_policy_attachment" "change_password" {
  provider = aws.current
  count = var.console ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
  user = aws_iam_user.this.name
}

resource "aws_iam_user_policy" "manage_access_keys"    {
  provider = aws.current
  count = var.console ? 1 : 0
  name = "manage_access_keys"
  user = aws_iam_user.this.name
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid = "ManageOwnAccessKeys"
          Effect = "Allow"
          Action = [
            "iam:CreateAccessKey",
            "iam:DeleteAccessKey",
            "iam:GetAccessKeyLastUsed",
            "iam:GetUser",
            "iam:ListAccessKeys",
            "iam:UpdateAccessKey"
          ]
          Resource = "arn:aws:iam::*:user/${aws_iam_user.this.name}"
        }
      ]
    }
  )
}

resource "aws_iam_user_policy_attachment" "this" {
  provider = aws.current
  for_each = toset(var.policy_arns)
  policy_arn = each.value
  user = aws_iam_user.this.name
}

resource "aws_iam_user_policy" "this"    {
  provider = aws.current
  for_each = var.policies
  name = each.key
  user = aws_iam_user.this.name
  policy = jsonencode(each.value)
}
