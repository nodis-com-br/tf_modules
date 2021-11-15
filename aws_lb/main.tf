module "bucket" {
  source = "../aws_s3"
  name = var.log_bucket_name
  policy = true
  role = false
  providers = {
    aws.current = aws.current
  }
  extra_bucket_policy_statements = [
    {
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${local.elb_account_id[data.aws_region.current.name]}:root"
      }
      Action = "s3:PutObject"
      Resource = "arn:aws:s3:::${var.log_bucket_name}/AWSLogs/*"
    },
    {
      Effect = "Allow"
      Principal = {
        Service = "delivery.logs.amazonaws.com"
      }
      Action = "s3:PutObject"
      Resource = "arn:aws:s3:::${var.log_bucket_name}/AWSLogs/*"
//      Condition = {
//        StringEquals = {
//          "s3:x-amz-acl?" = "bucket-owner-full-control"
//        }
//      }
    },
    {
      Effect = "Allow"
      Principal = {
        Service = "delivery.logs.amazonaws.com"
      }
      Action = "s3:GetBucketAcl"
      Resource = "arn:aws:s3:::${var.log_bucket_name}"
    }
  ]
}

resource "aws_alb" "this" {
  provider = aws.current
  subnets = var.subnet_ids
  security_groups = var.security_group_ids
  access_logs {
    bucket = module.bucket.this.bucket
    enabled = true
  }
}

resource "aws_alb_listener" "redirector" {
  provider = aws.current
  for_each = local.redirectors
  load_balancer_arn = aws_alb.this.arn
  port = try(each.value.port, "443")
  protocol = try(each.value.protocol, "HTTPS")
  certificate_arn = try(each.value.certificate_arn, null)
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

resource "aws_alb_listener" "forwarder" {
  provider = aws.current
  for_each = var.forwarders
  load_balancer_arn = aws_alb.this.arn
  port = try(each.value.port, "443")
  protocol = try(each.value.protocol, "HTTPS")
  certificate_arn = try(each.value.certificate_arn, null)
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.this[each.key].arn
  }
}

resource "aws_alb_target_group" "this" {
  provider = aws.current
  for_each = var.forwarders
  port = try(each.value.target_group.port, 80)
  protocol = try(each.value.target_group.protocol, "HTTP")
  vpc_id = try(each.value.target_group.vpc_id)
  target_type = each.value.target_group.type
  health_check {
    path = try(each.value.target_group.healthcheck, {path = "/"}).path
    matcher = try(each.value.target_group.healthcheck, {matcher = "200"}).matcher
  }
}

resource "aws_alb_target_group_attachment" "this" {
  provider = aws.current
  for_each = local.target_group_attachments
  target_group_arn = aws_alb_target_group.this[each.value.forwarder].arn
  target_id = each.value.id
}

