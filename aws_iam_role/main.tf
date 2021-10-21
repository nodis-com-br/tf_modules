module "defaults" {
  source = "../_defaults"
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

resource "aws_iam_role_policy" "this" {
  provider = aws.current
  for_each = var.policies
  role = aws_iam_role.this.id
  policy = each.value
}

resource "aws_iam_role_policy_attachment" "this" {
  provider = aws.current
  for_each = toset(local.policy_arns)
  role = aws_iam_role.this.id
  policy_arn = each.value
}

resource "vault_generic_secret" "this" {
  count = var.vault_kv_path == null ? 0 : 1
  path = var.vault_kv_path
  data_json = jsonencode({
    arn = aws_iam_role.this.arn
  })
}