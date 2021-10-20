output "this" {
  value = var.alias == null ? aws_route53_record.this : aws_route53_record.alias
}

output "certificate" {
  value = var.create_certificate ? aws_acm_certificate.this.0 : null
}