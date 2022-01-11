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


resource "aws_instance" "this" {
  provider = aws.current
  count = var.host_count
  ami = var.ami
  ebs_optimized = true
  instance_type = var.type
  monitoring = false
  key_name = var.key_name
  subnet_id = element(var.subnets, (local.subnet_count + count.index) % local.subnet_count).id
  iam_instance_profile =
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

### Volumes ###########################

//resource "aws_ebs_volume" "this" {
//  provider = aws.current
//  for_each = var.volumes
//  availability_zone = aws_instance.this.0.availability_zone
//  size = each.value.size
//}
//
//resource "aws_volume_attachment" "this" {
//  provider = aws.current
//  for_each = var.volumes
//  device_name = each.key
//  volume_id   = aws_ebs_volume.this[each.key].id
//  instance_id = aws_instance.this.0.id
//}

resource "aws_eip" "this" {
  provider = aws.current
  count = var.dns_record != null ? 1 : 0
  instance = aws_instance.this.0.id
  vpc = true
}

resource "aws_route53_record" "this" {
  provider = aws.dns
  count = var.dns_record != null ? 1 : 0
  zone_id = var.dns_record.zone.id
  name = var.dns_record.hostname
  type = "A"
  ttl = "300"
  records = [
    aws_eip.this.0.public_ip
  ]
}

### DNS ###############################

module "private_dns_record" {
  source = "../aws_route53_record"
  count = var.host_count
  name = "${var.rg.name}-${var.name}${format("%04.0f", count.index + 1)}.${var.private_domain}"
  route53_zone = var.route53_zone
  records = [
    azurerm_network_interface.this[count.index].private_ip_address
  ]
  providers = {
    aws.current = aws.dns
  }
}