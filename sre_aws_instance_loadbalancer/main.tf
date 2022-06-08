module "certificate" {
  source = "../aws_acm_certificate"
  domain_name = var.name
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
    prod = {
      from_port = 0
      protocol = -1
      cidr_blocks = var.instance_subnet_blocks
      ipv6_cidr_blocks = []
    }
  }
  providers = {
    aws.current = aws.current
  }
}

module "target_group" {
  source = "../aws_loadbalancer_target_group"
  target_type = "instance"
  vpc = var.vpc
  targets = var.instances
  providers = {
    aws.current = aws.current
  }
}

module "load_balancer" {
  source = "../aws_loadbalancer"
  subnet_ids = var.subnet_ids
  log_bucket_name = var.log_bucket_name
  security_group_ids = [
    module.security_group.this.id,
  ]
  builtin_listeners = [
    "http_to_https"
  ]
  listeners = {
    web0001 = {
      certificate = module.certificate.this
      actions = {
        1 = {
          type = "forward"
          target_group_arn = module.target_group.this.arn
        }
      }
    }
  }
  region = var.region
  account_id = var.account_id
  providers = {
    aws.current = aws.current
  }
}

module "dns_record" {
  source = "../aws_route53_record"
  name = var.name
  route53_zone = var.route53_zone
  type = "CNAME"
  records = [
    module.load_balancer.this.dns_name
  ]
  providers = {
    aws.current = aws.dns
  }
}

