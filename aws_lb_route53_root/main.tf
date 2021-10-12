module "dns_record" {
  source = "../aws_route53_record"
  name = var.route53_zone.name
  route53_zone = var.route53_zone
  alias = {
    name = aws_alb.this.dns_name
    zone_id = aws_alb.this.zone_id
  }
  create_certificate = true
}

module "security_group" {
  source = "../aws_security_group"
  vpc = var.vpc
  builtin_ingress_rules = [
    "http",
    "https"
  ]
}

module "load_balancer" {
  source = "../aws_lb"
  subnet_ids = var.subnet_ids
  security_group_ids = [
    module.security_group.this.id,
  ]
  redirectors = {
    https = {action = {host = var.alias}}
  }
  builtin_redirectors = [
    "http_to_https"
  ]
}


resource "aws_alb" "this" {
  subnets = var.subnet_ids
  security_groups = [
    module.security_group.this.id,
  ]
}

//resource "aws_alb_listener" "http" {
//  load_balancer_arn = aws_alb.this.arn
//  port = 80
//  protocol = "HTTP"
//  default_action {
//    type  = "redirect"
//    redirect {
//      host = "#{host}"
//      path = "/#{path}"
//      port = "443"
//      protocol = "HTTPS"
//      query = "#{query}"
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
//    type  = "redirect"
//    redirect {
//      host = var.alias
//      path = "/#{path}"
//      port = "443"
//      protocol = "HTTPS"
//      query = "#{query}"
//      status_code = "HTTP_301"
//    }
//  }
//}