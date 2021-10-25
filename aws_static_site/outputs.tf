output "bucket_policy" {
  value = module.bucket.policy
}

output "cloudfront_policy" {
  value = var.cloudfront_policy ? aws_iam_policy.this.0 : null
}

output "role" {
  value = var.role ? module.role.this : null
}