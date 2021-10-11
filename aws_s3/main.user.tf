resource "aws_iam_user" "this" {
  provider = aws.current
  count = var.access_key ? 1 : 0
  name = var.username == null ? var.name : var.username
}

resource "aws_iam_access_key" "this" {
  count = var.access_key ? 1 : 0
  provider = aws.current
  user = aws_iam_user.this.0.name
}

resource "aws_iam_user_policy_attachment" "this" {
  count = var.access_key ? 1 : 0
  provider = aws.current
  policy_arn = aws_iam_policy.this.arn
  user = aws_iam_user.this.0.name
}
