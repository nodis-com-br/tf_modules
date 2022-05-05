output "this" {
  value = aws_cloudfront_distribution.this
}

output "bucket_policy" {
  value = module.bucket.policy
}

output "cloudfront_policy" {
  value = try(aws_iam_policy.this.0, null)
}

output "role" {
  value = try(module.role.0.this, null)
}