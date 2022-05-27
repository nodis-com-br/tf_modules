module "bucket" {
  source = "../aws_s3"
  name = var.bucket_name
  bucket_policy_statements = [
    {
      Sid = "AWSCloudTrailAclCheck"
      Effect = "Allow"
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      }
      Action = "s3:GetBucketAcl"
      Resource = "arn:aws:s3:::${var.bucket_name}"
    },
    {
      Sid = "AWSCloudTrailWrite"
      Effect = "Allow"
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      }
      Action = "s3:PutObject"
      Resource = "arn:aws:s3:::${var.bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
      Condition = {
        StringEquals = {
          "s3:x-amz-acl" = "bucket-owner-full-control"
        }
      }
    }
  ]
  providers = {
    aws.current = aws.current
  }
}

resource "aws_cloudtrail" "this" {
  provider = aws.current
  name = var.name
  s3_bucket_name = module.bucket.this.id
  include_global_service_events = var.include_global_service_events
}