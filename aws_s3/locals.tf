locals {
  default_policy = jsonencode({
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
  bucket_policy_statements = {
    require_ssl = {
      Principal: "*"
      Effect: "Deny"
      Action: [
        "s3:*"
      ]
      Resource = [
        "arn:aws:s3:::${var.name}",
        "arn:aws:s3:::${var.name}/*"
      ]
      Condition: {
        Bool: {
          "aws:SecureTransport": "false"
        }
      }
    }
  }
  default_bucket_policy_statements = ["require_ssl"]
  selected_bucket_policy_statements = [for s in concat(var.bucket_policy_statements, local.default_bucket_policy_statements): local.bucket_policy_statements[s]]
  bucket_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [for s in concat(var.extra_bucket_policy_statements, local.selected_bucket_policy_statements): s]
  })
}