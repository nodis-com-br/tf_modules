//resource "aws_route53_record" "this" {
//  zone_id = var.route53_zone.id
//  name = var.route53_zone.name
//  type = "A"
//  alias {
//    name = aws_alb.this.dns_name
//    zone_id = aws_alb.this.zone_id
//    evaluate_target_health = false
//  }
//}
//
//resource "aws_acm_certificate" "this" {
//  domain_name = var.route53_zone.name
//  validation_method = "DNS"
//  lifecycle {
//    create_before_destroy = true
//  }
//}
//
//resource "aws_route53_record" "certificate_record" {
//  for_each = {
//    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
//      name = dvo.resource_record_name
//      record = dvo.resource_record_value
//      type = dvo.resource_record_type
//    }
//  }
//  zone_id = var.route53_zone.id
//  name = each.value.name
//  type = each.value.type
//  ttl = 300
//  records = [
//    each.value.record
//  ]
//
//}
//
//resource "aws_security_group" "this" {
//  description = "Allow web access"
//  vpc_id = var.vpc.id
//  tags = {
//    Name = "${var.route53_zone.name}-http"
//  }
//  lifecycle {
//    create_before_destroy = true
//  }
//  ingress {
//    from_port = 80
//    to_port = 80
//    protocol = "tcp"
//    cidr_blocks = [
//      "0.0.0.0/0"
//    ]
//    ipv6_cidr_blocks = [
//      "::/0"
//    ]
//  }
//  ingress {
//    from_port = 443
//    to_port = 443
//    protocol = "tcp"
//    cidr_blocks = [
//      "0.0.0.0/0"
//    ]
//    ipv6_cidr_blocks = [
//      "::/0"
//    ]
//  }
//}

module "dns_record" {
  source = "../aws_route53_record"
  name = var.route53_zone.name
  route53_zone = var.route53_zone
  records = [
    aws_alb.this.dns_name
  ]
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


resource "aws_alb" "this" {
  subnets = var.subnet_ids
  security_groups = [
    module.security_group.this.id,
  ]
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.this.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type  = "redirect"
    redirect {
      host = "#{host}"
      path = "/#{path}"
      port = "443"
      protocol = "HTTPS"
      query = "#{query}"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.this.arn
  port = 443
  protocol = "HTTPS"
  certificate_arn = module.dns_record.certificate.arn
  default_action {
    type  = "redirect"
    redirect {
      host = var.alias
      path = "/#{path}"
      port = "443"
      protocol = "HTTPS"
      query = "#{query}"
      status_code = "HTTP_301"
    }
  }
}