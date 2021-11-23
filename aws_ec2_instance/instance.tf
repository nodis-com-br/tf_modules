resource "aws_security_group" "this" {
  provider = aws.current
  vpc_id = var.subnets.0.vpc_id
  lifecycle {
    create_before_destroy = true
  }
  ingress {
    self = true
    from_port = 0
    protocol = -1
    to_port = 0
  }
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      protocol = ingress.value.protocol
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      security_groups = ingress.value.security_groups
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      protocol = egress.value.protocol
      from_port = egress.value.from_port
      to_port = egress.value.to_port
      security_groups = egress.value.security_groups
      cidr_blocks = egress.value.cidr_blocks
    }
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
  vpc_security_group_ids = [
    aws_security_group.this.id
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

resource "aws_ebs_volume" "this" {
  provider = aws.current
  for_each = var.volumes
  availability_zone = aws_instance.this.0.availability_zone
  size = each.value.size
}

resource "aws_volume_attachment" "this" {
  provider = aws.current
  for_each = var.volumes
  device_name = each.key
  volume_id   = aws_ebs_volume.this[each.key].id
  instance_id = aws_instance.this.0.id
}

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
