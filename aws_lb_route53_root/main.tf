module "dns_record" {
  source = "../aws_route53_record"
  name = var.route53_zone.name
  route53_zone = var.route53_zone
  alias = {
    name = module.load_balancer.this.dns_name
    zone_id = module.load_balancer.this.zone_id
  }

  providers = {
    aws.current = aws.dns
  }
}

module "certificate" {
  source = "../aws_acm_certificate"
  domain_name = var.route53_zone.name
  route53_zone = var.route53_zone
  providers = {
    aws.current = aws.currennt
    aws.dns = aws.dns
  }
}

module "security_group" {
  source = "../aws_security_group"
  vpc = var.vpc
  builtin_ingress_rules = [
    "http",
    "https"
  ]
  providers = {
    aws.current = aws.current
  }
}

module "load_balancer" {
  source = "../aws_lb"
  subnet_ids = var.subnet_ids
  security_group_ids = [
    module.security_group.this.id,
  ]
  redirectors = {
    https = {
      certificate_arn = module.certificate.this.arn
      action = {host = var.alias}}
  }
  builtin_redirectors = [
    "http_to_https"
  ]
  providers = {
    aws.current = aws.current
  }
}