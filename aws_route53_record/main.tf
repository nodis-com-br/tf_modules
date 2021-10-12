resource "aws_route53_record" "this" {
  provider = aws.dns
  count = var.alias == null ? 1 : 0
  zone_id = var.route53_zone.id
  name = var.name
  type = var.type
  ttl = var.ttl
  records = var.records
}

resource "aws_route53_record" "alias" {
  provider = aws.dns
  count = var.alias == null ? 0 : 1
  zone_id = var.route53_zone.id
  name = var.name
  type = var.type
  alias {
    evaluate_target_health = try(var.alias.evaluate_target_health, false)
    name  = var.alias.name
    zone_id = var.alias.zone_id
  }
}

resource "aws_acm_certificate" "this" {
  provider = aws.dns
  count = var.create_certificate ? 1 : 0
  domain_name  = var.name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_route53_record" "certificate_validation" {
  provider = aws.dns
  for_each = var.create_certificate ? {
    for dvo in aws_acm_certificate.this.0.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}
  zone_id = var.route53_zone.id
  name    = each.value.name
  type    = each.value.type
  ttl = 300
  records = [
    each.value.record
  ]
}