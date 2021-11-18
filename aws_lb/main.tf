module "bucket" {
  source = "../aws_s3"
  name = var.log_bucket_name
  policy = false
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
      Resource = "arn:aws:s3:::${var.log_bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    },
    {
      Effect = "Allow"
      Principal = {
        Service = "delivery.logs.amazonaws.com"
      }
      Action = "s3:PutObject"
      Resource = "arn:aws:s3:::${var.log_bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
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
    bucket = module.bucket.this.id
    enabled = true
  }
}

module "redirector" {
  source = "../aws_lb_listener"
  for_each = local.listeners
  load_balancer = aws_alb.this
  port = try(each.value.port, "443")
  protocol = try(each.value.protocol, "HTTPS")
  certificate = try(each.value.certificate, null)
  actions = try(each.value.actions, {})
  builtin_actions = try(each.value.builtin_actions, [])
//    1 = {
//      type = "redirect"
//      options = {
//        host = each.value.action.host
//        port = try(each.value.action.port, "443")
//        protocol = try(each.value.action.protocol, "HTTPS")
//        status_code = try(each.value.action.status_code, "HTTP_301")
//      }
//    }
//  }
  providers = {
    aws.current = aws.current
  }
}

module "forwarder" {
  source = "../aws_lb_listener"
  for_each = var.forwarders
  load_balancer = aws_alb.this
  port = try(each.value.port, "443")
  protocol = try(each.value.protocol, "HTTPS")
  certificate = try(each.value.certificate, null)
  actions = {
    1 = {
      type = "forward"
      target_group_arn = aws_alb_target_group.this[each.key].arn
    }
  }
  providers = {
    aws.current = aws.current
  }
}


//resource "aws_alb_listener" "forwarder" {
//  provider = aws.current
//  for_each = var.forwarders
//  load_balancer_arn = aws_alb.this.arn
//  port = try(each.value.port, "443")
//  protocol = try(each.value.protocol, "HTTPS")
//  certificate_arn = try(each.value.certificate.arn, null)
//  default_action {
//    type = "forward"
//    target_group_arn = aws_alb_target_group.this[each.key].arn
//  }
//}

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

