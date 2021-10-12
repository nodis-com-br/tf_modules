locals {
  builtin_rules = {
    all = {
      from_port = 0
      protocol = -1
    }
    http = {
      from_port = 80
    },
    https = {
      from_port = 443
    }
  }
  selected_builtin_ingress_rules = { for r in var.builtin_ingress_rules : r => local.builtin_rules[r] }
  ingress_rules = merge(var.ingress_rules, local.selected_builtin_ingress_rules)
  selected_builtin_egress_rules = { for r in var.builtin_ingress_rules : r => local.builtin_rules[r] }
  egress_rules = merge(var.egress_rules, local.selected_builtin_egress_rules)
}