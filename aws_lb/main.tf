resource "aws_alb" "this" {
  subnets = var.subnet_ids
  security_groups = var.security_group_ids
}

resource "aws_alb_listener" "redirector" {
  for_each = local.redirectors
  load_balancer_arn = aws_alb.this.arn
  port = try(each.value.port, "443")
  protocol = try(each.value.protocol, "HTTPS")
  certificate_arn = try(each.value.certificate_arn, null)
  default_action {
    type  = "redirect"
    redirect {
      host = each.value.action.host
      path = try(each.value.action.path, "/#{path}")
      port = try(each.value.action.port, "443")
      protocol = try(each.value.action.protocol, "HTTPS")
      query = try(each.value.action.query, "#{query}")
      status_code = try(each.value.action.status_code, "HTTP_301")
    }
  }
}

resource "aws_alb_listener" "forwarders" {
  for_each = var.forwarders
  load_balancer_arn = aws_alb.this.arn
  port = try(each.value.port, "443")
  protocol = try(each.value.protocol, "HTTPS")
  certificate_arn = try(each.value.certificate_arn, null)
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.this[each.key].arn
  }
}

resource "aws_alb_target_group" "this" {
  for_each = var.forwarders
  port = try(each.value.action.port, 80)
  protocol = try(each.value.action.protocol, "HTTP")
  vpc_id = try(each.value.action.vpc_id)
  target_type = each.value.action.target_type
  health_check {
    path = try(each.value.action.healthcheck, {path = "/"}).path
    matcher = try(each.value.action.healthcheck, {matcher = "200"}).matcher
  }
}

resource "aws_alb_target_group_attachment" "this" {
  for_each = var.target_group_attachments
  target_group_arn = aws_alb_target_group.this[each.value.forwarder]
  target_id = each.value.id
}