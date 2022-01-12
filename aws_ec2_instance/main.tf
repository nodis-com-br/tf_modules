module "security_group" {
  source = "../aws_security_group"
  vpc = var.vpc
  ingress_rules = var.ingress_rules
  builtin_ingress_rules = var.builtin_ingress_rules
  egress_rules = var.egress_rules
  builtin_egress_rules = var.builtin_egress_rules
  providers = {
    aws.current = aws.current
  }
}

module "role" {
  source = "../aws_iam_role"
  count = var.instance_role ? 1 : 0
  policies = var.instance_role_policies
  providers = {
    aws.current = aws.current
  }
}

resource "aws_iam_instance_profile" "this" {
  count = var.instance_role ? 1 : 0
  role = module.role.this.name
}

resource "aws_instance" "this" {
  provider = aws.current
  count = var.host_count
  ami = var.ami
  ebs_optimized = true
  instance_type = var.type
  monitoring = false
  key_name = var.key_name
  subnet_id = element(var.subnets, (local.subnet_count + count.index) % local.subnet_count).id
  iam_instance_profile = var.instance_role ? aws_iam_instance_profile.this.0.id : null
  vpc_security_group_ids = [
    module.security_group.this.id
  ]
  source_dest_check = var.source_dest_check
  root_block_device {
    volume_type = var.root_volume.volume_type
    volume_size = var.root_volume.volume_size
    delete_on_termination = var.root_volume.delete_on_termination
  }

  tags = merge({
    Name = "${var.name}${format("%04.0f", count.index + 1)}"
  }, var.tags)
}

resource "aws_eip" "this" {
  provider = aws.current
  count = var.fixed_public_ip ? var.host_count : 0
  instance = aws_instance.this[count.index].id
  vpc = true
}

module "private_dns_record" {
  source = "../aws_route53_record"
  count = var.host_count
  name = "${var.account}-${var.name}${format("%04.0f", count.index + 1)}.${var.private_domain}"
  route53_zone = var.route53_zone
  records = [
    aws_instance.this[count.index].private_ip
  ]
  providers = {
    aws.current = aws.dns
  }
}

module "public_dns_record" {
  source = "../aws_route53_record"
  count = var.domain == null ? 0 : 1
  name = var.domain
  route53_zone = var.route53_zone
  records = [for i in aws_instance.this : i.public_ip]
  providers = {
    aws.current = aws.dns
  }
}