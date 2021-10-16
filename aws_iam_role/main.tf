module "defaults" {
  source = "../defaults"
}

resource "aws_iam_role" "this" {
  provider = aws.current
  name = var.name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.owner_arn
        }
      }
    ]
  })
}

resource "aws_iam_policy" "this" {
  provider = aws.current
  for_each = var.policies
  path = "/"
  description = ""
  policy = jsonencode(each.value)
}

resource "aws_iam_role_policy_attachment" "this" {
  provider = aws.current
  for_each = var.policies
  role = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this[each.key].arn
}

resource "aws_iam_role_policy_attachment" "that" {
  provider = aws.current
  for_each = toset(local.policy_arns)
  role = aws_iam_role.this.name
  policy_arn = each.value
}

