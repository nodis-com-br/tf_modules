output "bucket_policy" {
  value = module.bucket.policy
}

output "cloudfront_policy" {
  value = aws_iam_policy.this
}