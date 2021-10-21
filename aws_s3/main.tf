module "defaults" {
  source = "../_defaults"
}

resource "aws_s3_bucket" "this" {
  provider = aws.current
  bucket = var.name
  acl = "private"
  force_destroy = false
}

resource "aws_iam_policy" "this" {
  count = var.policy ? 1 : 0
  provider = aws.current
  policy = local.default_policy
}

resource "vault_generic_secret" "this" {
  count = alltrue([var.policy, var.save_policy_arn]) ? 1 : 0
  path = "${local.vault_kv_path}/policy/${var.name}"
  data_json = jsonencode({
    arn = aws_iam_policy.this.0.arn
  })
}

module "role" {
  source = "../aws_iam_role"
  count = var.role ? 1 : 0
  owner_arn = var.role_owner_arn
  policies = {1 = local.default_policy}
  vault_kv_path = var.save_role_arn ? "${local.vault_kv_path}/role/${var.name}" : null
  providers = {
    aws.current = aws.current
  }
}

module "user" {
  source = "../aws_iam_user"
  count = var.access_key ? 1 : 0
  username = aws_s3_bucket.this.bucket
  access_key = true
  policies = {1 = local.default_policy}
  providers = {
    aws.current = aws.current
  }
}
