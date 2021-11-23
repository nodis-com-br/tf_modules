module "defaults" {
  source = "../_aws_defaults"
}

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
  user = aws_iam_user.this.name
  pgp_key = var.pgp_key
  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
}

resource "aws_iam_policy" "this" {
  provider = aws.current
  for_each = local.all_policies
  policy = each.value
}

resource "aws_iam_user_policy_attachment" "this" {
  provider = aws.current
  for_each = local.all_policies
  policy_arn = aws_iam_policy.this[each.key].arn
  user = aws_iam_user.this.name
}

resource "aws_iam_user_policy_attachment" "that" {
  provider = aws.current
  for_each = toset(local.policy_arns)
  policy_arn = each.key
  user = aws_iam_user.this.name
}

resource "aws_iam_user_policy" "assume_role" {
  provider = aws.current
  for_each = toset(var.assume_role_arns)
  user = aws_iam_user.this.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sts:AssumeRole"
        ],
        Resource = [
          each.key
        ]
      }
    ]
  })

}

