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
  provider = aws.current
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListAllMyBuckets"
        ],
        Resource = [
          "arn:aws:s3:::*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListBucketMultipartUploads",
          "s3:ListBucketVersions"
        ],
        Resource = [
          aws_s3_bucket.this.arn
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts"
        ],
        Resource = [
          "${aws_s3_bucket.this.arn}/*"
        ]
      }
    ]
  })
}

resource "vault_generic_secret" "this" {
  count = var.save_policy_arn ? 1 : 0
  path = "${local.vault_kv_path}/policy/${var.name}"
  data_json = jsonencode({
    arn = aws_iam_policy.this.arn
  })
}

module "role" {
  source = "../aws_iam_role"
  count = var.role ? 1 : 0
  owner_arn = var.role_owner_arn
  policy_arns = [aws_iam_policy.this.arn]
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
  policy_arns = [aws_iam_policy.this.arn]
  providers = {
    aws.current = aws.current
  }
}
