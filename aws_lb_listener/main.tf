resource "aws_lb_listener" "this" {
  provider = aws.current
  load_balancer_arn = var.load_balancer.arn
  port = var.port
  protocol = var.protocol
  certificate_arn = var.certificate.arn
  dynamic "default_action" {
    for_each = var.actions
    content {
      order = default_action.key
      type = default_action.value.type
      target_group_arn = default_action.value.type == "forwarder" ? default_action.value.target_group_arn : null
      fixed_response = default_action.value.type == "fixed-response" ? default_action.value.fixed_response : null
      dynamic "redirect" {
        for_each = default_action.value.type == "redirect" ? {0 = default_action.value.options} : {}
        content {
          host = try(redirect.value.host)
          path = try(redirect.value.path)
          port = try(redirect.value.port)
          protocol = try(redirect.value.protocol)
          query = try(redirect.value.query)
          status_code = try(redirect.value.status_code)
        }
      }
    }
  }
}

resource "aws_lb_listener_rule" "this" {
  for_each = var.rules
  priority = each.key
  listener_arn = aws_lb_listener.this.arn
  action {
    type = var.actions[each.key].type
    dynamic "redirect" {
      for_each = var.actions[each.key].type == "redirect" ? {0 = var.actions[each.key].options} : {}
      content {
        host = redirect.value.host
        path = try(redirect.value.path, local.default_action_values.redirect.path)
        port = try(redirect.value.port, local.default_action_values.redirect.port)
        protocol = try(redirect.value.protocol, local.default_action_values.redirect.protocol)
        query = try(redirect.value.query, local.default_action_values.redirect.query)
        status_code = try(redirect.value.status_code, local.default_action_values.redirect.status_code)
      }
    }
  }
  dynamic "condition" {
    for_each = each.value.conditions
    content {
      dynamic "host_header" {
        for_each = try(condition.value.host_header) != null ? {0 = condition.value.host_header} : {}
        content {
          values = host_header.value.values
        }
      }
    }
  }
}
