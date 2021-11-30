module "certificate" {
  source = "../aws_acm_certificate"
  domain_name = local.domain_name
  subject_alternative_names = local.subject_alternative_names
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
  egress_rules = {
    1 = {
      from_port = 0
      protocol = -1
      cidr_blocks = [for s in var.subnets : s.cidr_block]
      ipv6_cidr_blocks = []
    }
  }
  providers = {
    aws.current = aws.current
  }
}

module "load_balancer" {
  source = "../aws_lb"
  subnet_ids = [for s in var.subnets : s.id]
  log_bucket_name = var.log_bucket_name
  security_group_ids = [
    module.security_group.this.id
  ]
  listeners = {
    1 = {
      port = var.port
      protocol = var.protocol
      certificate = module.certificate.this
      actions = var.actions
      rules = var.rules
    }
  }
  builtin_listeners = ["http_to_https"]
  providers = {
    aws.current = aws.current
  }
}

module "dns_record" {
  source = "../aws_route53_record"
  for_each = toset(var.domains)
  name = each.value
  route53_zone = var.route53_zone
  alias = {
    name = module.load_balancer.this.dns_name
    zone_id = module.load_balancer.this.zone_id
  }
  providers = {
    aws.current = aws.dns
  }
}