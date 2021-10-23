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

module "acm_certificate" {
  source = "../aws_acm_certificate"
  count = var.create_certificate ? 1 : 0
  domain_name = var.name
  route53_zone = var.route53_zone
  providers = {
    aws.current = aws.current
    aws.dns = aws.dns
  }
}