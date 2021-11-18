resource "aws_alb_listener" "this" {
  provider = aws.current
  load_balancer_arn = var.load_balancer.arn
  port = var.port
  protocol = var.protocol
  certificate_arn = var.certificate == null ? null : var.certificate.arn
  dynamic "default_action" {
    for_each = local.actions
    content {
      order = default_action.key
      type = default_action.value.type
      target_group_arn = default_action.value.type == "forward" ? default_action.value.target_group_arn : null
      dynamic "redirect" {
        for_each = default_action.value.type == "redirect" ? {0 = default_action.value.options} : {}
        content {
          host = try(redirect.value.host, null)
          path = try(redirect.value.path, null)
          port = try(redirect.value.port, null)
          protocol = try(redirect.value.protocol, null)
          query = try(redirect.value.query, null)
          status_code = try(redirect.value.status_code, "HTTP_301")
        }
      }
    }
  }
}

//resource "aws_lb_listener_rule" "this" {
//  provider = aws.current
//  for_each = var.rules
//  priority = each.key
//  listener_arn = aws_alb_listener.this.arn
//  action {
//    type = var.actions[each.key + local.selected_builtin_actions_count].type
//    dynamic "redirect" {
//      for_each = var.actions[each.key].type == "redirect" ? {0 = var.actions[each.key + local.selected_builtin_actions_count].options} : {}
//      content {
//        host = try(redirect.value.host, null)
//        path = try(redirect.value.path, null)
//        port = try(redirect.value.port, null)
//        protocol = try(redirect.value.protocol, null)
//        query = try(redirect.value.query, null)
//        status_code = try(redirect.value.status_code, "HTTP_301")
//      }
//    }
//  }
//  dynamic "condition" {
//    for_each = each.value.conditions
//    content {
//      dynamic "host_header" {
//        for_each = try(condition.value.host_header) != null ? {0 = condition.value.host_header} : {}
//        content {
//          values = host_header.value.values
//        }
//      }
//    }
//  }
//}
