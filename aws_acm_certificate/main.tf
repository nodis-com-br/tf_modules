resource "aws_acm_certificate" "this" {
  provider = aws.current
  domain_name  = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "certificate_validation" {
  provider = aws.dns
  for_each = { for dvo in aws_acm_certificate.this.0.domain_validation_options : dvo.domain_name =>
    {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  zone_id = var.route53_zone.id
  name = each.value.name
  type = each.value.type
  ttl = 300
  records = [
    each.value.record
  ]
}