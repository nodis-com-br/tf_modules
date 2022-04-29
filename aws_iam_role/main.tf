resource "aws_iam_role" "this" {
  provider = aws.current
  name = var.name
  assume_role_policy = local.assume_role_policies[var.assume_role_policy]
  tags = {}
  lifecycle {
    ignore_changes = [
      inline_policy,
      managed_policy_arns
    ]
  }
}

resource "aws_iam_role_policy" "this" {
  provider = aws.current
  for_each = var.policies
  role = aws_iam_role.this.id
  policy = each.value
}

resource "aws_iam_role_policy_attachment" "this" {
  provider = aws.current
  for_each = {for i, v in var.policy_arns : i => v}
  role = aws_iam_role.this.id
  policy_arn = each.value
}

module "vault_role" {
  source = "../vault_aws_role"
  count = var.vault_role != null ? 1 : 0
  name = var.vault_role
  credential_type = var.vault_credential_type
  backend = var.vault_backend
  role_arns = [aws_iam_role.this.arn]
}

resource "vault_generic_secret" "this" {
  count = var.vault_kv_path == null ? 0 : 1
  path = var.vault_kv_path
  data_json = jsonencode({
    arn = aws_iam_role.this.arn
  })
}