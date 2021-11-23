resource "aws_db_subnet_group" "this" {
  provider = aws.current
  subnet_ids  = var.subnet_id_list
}

resource "aws_iam_role" "this" {
  provider = aws.current
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
        Sid = ""
      }
    ]
    Version = "2012-10-17"
  })
}

resource "aws_db_instance" "this" {
  provider = aws.current
  identifier = var.name
  allocated_storage = var.allocated_storage
  max_allocated_storage = var.max_storage
  storage_type = "gp2"
  username = var.username
  password = var.password
  engine = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  port = var.port
  publicly_accessible = var.public_accessible
  security_group_names = []
  vpc_security_group_ids = [
    aws_security_group.this.id
  ]
  db_subnet_group_name = aws_db_subnet_group.this.name
  multi_az = false
  backup_retention_period = 7
  storage_encrypted = true
  deletion_protection = var.deletion_protection
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.this.arn
  performance_insights_enabled = var.performance_insights_enabled
  skip_final_snapshot = true
  copy_tags_to_snapshot = true
  apply_immediately = true
  tags = var.tags
  lifecycle {
    ignore_changes = [
      monitoring_interval,
    ]
  }
}

resource "aws_security_group" "this" {
  provider = aws.current
  vpc_id = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      protocol = ingress.value.protocol
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      protocol = egress.value.protocol
      from_port = egress.value.from_port
      to_port = egress.value.to_port
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

resource "aws_route53_record" "this" {
  provider = aws.dns
  count = var.dns_record != null ? 1 : 0
  zone_id = var.dns_record.zone.id
  name = var.dns_record.hostname
  type = "CNAME"
  ttl = "300"
  records = [
    aws_db_instance.this.address
  ]
}
