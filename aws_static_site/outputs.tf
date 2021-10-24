output "bucket_policy" {
  value = module.bucket.policy
}

output "cloudfront_policy" {
  value = var.cloudfront_enabled ? aws_iam_policy.this.0 : null
}