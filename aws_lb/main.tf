resource "aws_alb" "this" {
  subnets = var.subnet_ids
  security_groups = var.security_group_ids
}

resource "aws_alb_listener" "redirector" {
  for_each = local.redirectors
  load_balancer_arn = aws_alb.this.arn
  port = try(each.value.port, "443")
  protocol = try(each.value.protocol, "HTTPS")
  certificate_arn = try(each.value.certificate, null)
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
