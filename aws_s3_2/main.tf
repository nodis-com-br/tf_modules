resource "aws_s3_bucket" "this" {
  provider = aws.current
  bucket = var.name
  force_destroy = var.force_destroy
  lifecycle {
    ignore_changes = [
      server_side_encryption_configuration
    ]
  }
}

resource "aws_s3_bucket_acl" "this" {
  provider = aws.current
  bucket = aws_s3_bucket.this.id
  acl = var.acl
}

resource "aws_s3_bucket_versioning" "this" {
  provider = aws.current
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning
  }
}

resource aws_s3_bucket_server_side_encryption_configuration "this" {
  provider = aws.current
  bucket = aws_s3_bucket.this.id
  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.server_side_encryption.kms_master_key_id
      sse_algorithm = var.server_side_encryption.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  provider = aws.current
  bucket = aws_s3_bucket.this.id
  policy = local.bucket_policy
}

module "policy" {
  source = "../aws_iam_policy"
  policy = coalesce(var.policy, local.default_policy)
  providers = {
    aws.current = aws.current
  }
}

module "role" {
  source = "../aws_iam_role"
  count = var.role ? 1 : 0
  owner_arn = var.role_owner_arn
  policy_arns = [module.policy.this.arn]
  vault_role = var.vault_role
  vault_credential_type = var.vault_credential_type
  vault_backend = var.vault_backend
  providers = {
    aws.current = aws.current
  }
}