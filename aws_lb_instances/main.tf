module "dns_record" {
  source = "../aws_route53_record"
  name = var.name
  route53_zone = var.route53_zone
  type = "CNAME"
  records = [
    module.load_balancer.this.dns_name
  ]
  providers = {
    aws.dns = aws.dns
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
  egress_rules = {
    prod = {
      from_port = 0
      protocol = -1
      cidr_blocks = var.instance_subnet_cidrs
      ipv6_cidr_blocks = []
    }
  }
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
  forwarders = {
    web0001 = {
      certificate_arn = module.certificate.this.arn
      target_group = {
        vpc_id = var.vpc.id
        type = "instance"
        targets = var.instances
      }
    }
  }
  builtin_redirectors = [
    "http_to_https"
  ]
  providers = {
    aws.current = aws.current
  }
}
