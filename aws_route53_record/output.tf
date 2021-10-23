output "this" {
  value = var.alias == null ? aws_route53_record.this.0 : aws_route53_record.alias.0
}