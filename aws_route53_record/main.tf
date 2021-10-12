resource "aws_route53_record" "this" {
  zone_id = var.route53_zone.id
  name = var.name
  type = var.type
  ttl = var.ttl
  records = var.records
}

resource "aws_acm_certificate" "this" {
  count = var.create_certificate ? 1 : 0
  domain_name  = var.name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  zone_id = var.route53_zone.id
  name    = each.value.name
  type    = each.value.type
  ttl = 300
  records = [
    each.value.record
  ]
}