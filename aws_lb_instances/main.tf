module "dns_record" {
  source = "../aws_route53_record"
  name = var.name
  route53_zone = var.route53_zone
  type = "CNAME"
  records = [
    module.load_balancer.this.dns_name
  ]
  create_certificate = true
  providers = {
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

### Load balancer #####################

module "load_balancer" {
  source = "../aws_lb"
  subnet_ids = var.subnet_ids
  security_group_ids = [
    module.security_group.this.id,
  ]
  forwarders = {
    web0001 = {
      certificate_arn = module.dns_record.certificate.arn
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
//
//resource "aws_alb" "this" {
//  subnets = var.subnet_ids
//  security_groups = [
//    module.security_group.this.id
//  ]
//}
//
//resource "aws_alb_listener" "http" {
//  load_balancer_arn = aws_alb.this.arn
//  port = 80
//  protocol = "HTTP"
//  default_action {
//    type  = "redirect"
//    redirect {
//      host        = "#{host}"
//      path        = "/#{path}"
//      port        = "443"
//      protocol    = "HTTPS"
//      query       = "#{query}"
//      status_code = "HTTP_301"
//    }
//  }
//}
//
//resource "aws_alb_listener" "https" {
//  load_balancer_arn = aws_alb.this.arn
//  port = 443
//  protocol = "HTTPS"
//  certificate_arn = module.dns_record.certificate.arn
//  default_action {
//    type = "forward"
//    target_group_arn = aws_alb_target_group.this.arn
//  }
//}
//
//resource "aws_alb_target_group" "this" {
//  port = 80
//  protocol = "HTTP"
//  vpc_id = var.vpc.id
//  target_type = "instance"
//  health_check {
//    path = "/"
//    matcher = "200"
//  }
//}
//
//resource "aws_alb_target_group_attachment" "this" {
//  for_each = var.instances
//  target_group_arn = aws_alb_target_group.this.arn
//  target_id = each.value.id
//}
//
//

