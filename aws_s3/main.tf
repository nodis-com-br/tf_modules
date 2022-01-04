module "defaults" {
  source = "../_aws_defaults"
}

resource "aws_s3_bucket" "this" {
  provider = aws.current
  bucket = var.name
  acl = var.acl
  force_destroy = false
  policy = local.bucket_policy
  versioning {
    enabled = var.versioning
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.server_side_encryption.kms_master_key_id
        sse_algorithm = var.server_side_encryption.sse_algorithm
      }
    }
  }
}

module "role" {
  source = "../aws_iam_role"
  count = var.role ? 1 : 0
  owner_arn = var.role_owner_arn
  policies = {1 = local.access_policy}
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
  policies = {1 = local.access_policy}
  providers = {
    aws.current = aws.current
  }
}

resource "aws_iam_policy" "this" {
  count = var.policy ? 1 : 0
  provider = aws.current
  policy = local.access_policy
}

resource "vault_generic_secret" "this" {
  count = alltrue([var.policy, var.save_policy_arn]) ? 1 : 0
  path = "${local.vault_kv_path}/policy/${var.name}"
  data_json = jsonencode({
    target = "bucket"
    arn = aws_iam_policy.this.0.arn
  })
}