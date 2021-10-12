resource "aws_security_group" "this" {
  vpc_id = var.vpc.id
  lifecycle {
    create_before_destroy = true
  }
  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port = ingress.value.from_port
      to_port = try(ingress.value.to_port, ingress.value.from_port)
      protocol = try(ingress.value.protocol, "tcp")
      cidr_blocks = try(ingress.value.cidr_blocks, ["0.0.0.0/0"])
      ipv6_cidr_blocks = try(ingress.value.ipv6_cidr_blocks, ["::/0"])
      prefix_list_ids = try(ingress.value.prefix_list_ids, [])
      security_groups = try(ingress.value.security_groups, [])
    }
  }
  dynamic "egress" {
    for_each = local.egress_rules
    content {
      from_port = egress.value.from_port
      to_port = try(egress.value.to_port, ingress.value.from_port)
      protocol = egress.value.protocol
      cidr_blocks = try(egress.value.cidr_blocks, ["0.0.0.0/0"])
      ipv6_cidr_blocks = try(egress.value.ipv6_cidr_blocks, ["::/0"])
      prefix_list_ids = try(egress.value.prefix_list_ids, [])
      security_groups = try(egress.value.security_groups, [])
    }
  }
}