locals {
  builtin_rules = {
    all = {from_port = 0, protocol = -1}
    http = {from_port = 80}
    https = {from_port = 443}
    ping = {from_port = 8, to_port = 0, protocol = "icmp"}
    ssh = {from_port = 22}
    nodeports_tcp = {protocol = "tcp", from_port = 30000, to_port = 32767}
    nodeports_udp = {protocol = "udp", from_port = 30000, to_port = 32767}
    mongodb = {from_port = 27017}
    postgres = {from_port = 5432}
    mysql = {from_port = 3306}
  }
  ingress_rules = merge(var.ingress_rules, {for r in var.builtin_ingress_rules : r => local.builtin_rules[r]})
  egress_rules = merge(var.egress_rules, {for r in var.builtin_egress_rules : r => local.builtin_rules[r]})
}