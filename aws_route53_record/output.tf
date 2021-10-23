output "this" {
  value = var.alias == null ? aws_route53_record.this.0 : aws_route53_record.alias.0
}

output "certificate" {
  value = var.create_certificate ? module.acm_certificate.this.0 : null
}