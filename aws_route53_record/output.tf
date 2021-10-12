output "certificate" {
  value = var.create_certificate ? aws_acm_certificate.this.0 : null
}