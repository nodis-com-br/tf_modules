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
    aws.current = aws.current
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
  log_bucket_name = var.log_bucket_name
  security_group_ids = [
    module.security_group.this.id
  ]
  builtin_listeners = [
    "http_to_https"
  ]
  listeners = {
    https = {
      certificate = module.certificate.this
      actions = {
        1 = {
          type = "redirect"
          options = {
            host = var.alias
          }
        }
      }
    }
  }
  providers = {
    aws.current = aws.current
  }
}