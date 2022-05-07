output "this" {
  value = aws_cloudfront_distribution.this
}

output "cloudfront_policy" {
  value = try(aws_iam_policy.this[0], null)
}

output "role_arn" {
  value = try(module.role[0].this.arn, null)
}