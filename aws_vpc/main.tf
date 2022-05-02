resource "aws_vpc" "this" {
    provider = aws.current
    cidr_block = var.ipv4_cidr
    assign_generated_ipv6_cidr_block = true
    enable_dns_hostnames = true
    enable_dns_support = true
    instance_tenancy = "default"
    tags = {
        Name = var.name
    }
}

resource "aws_default_security_group" "this" {
    provider = aws.current
    vpc_id = aws_vpc.this.id
    ingress {
        protocol = -1
        self = true
        from_port = 0
        to_port = 0
        cidr_blocks = local.allowed_ingress_cidr_blocks
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

resource "aws_vpc_peering_connection" "this" {
    provider = aws.current
    for_each = var.peering_requests
    peer_owner_id = each.value.account_id
    peer_vpc_id = each.value.vpc.id
    vpc_id = aws_vpc.this.id
}

resource "aws_vpc_peering_connection_accepter" "this" {
    provider = aws.current
    for_each = var.peering_accepters
    vpc_peering_connection_id = each.value.peering_request.id
    auto_accept = true
}


module "bucket" {
    source = "../aws_s3"
    role = false
    policy = false
    name = var.flow_logs_bucket_name
    extra_bucket_policy_statements = [
        {
            Sid = "AWSLogDeliveryWrite"
            Effect = "Allow"
            Principal = {
                Service = "delivery.logs.amazonaws.com"
            }
            Action = "s3:PutObject"
            Resource = "arn:aws:s3:::${var.flow_logs_bucket_name}/AWSLogs/${data.aws_caller_identity.this.account_id}/*"
            Condition = {
                StringEquals = {
                    "s3:x-amz-acl" = "bucket-owner-full-control"
                    "aws:SourceAccount" = data.aws_caller_identity.this.account_id
                }
                ArnLike = {
                    "aws:SourceArn" = "arn:aws:logs:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:*"
                }
            }
        },
        {
            Sid = "AWSLogDeliveryCheck"
            Effect = "Allow"
            Principal = {
                Service = "delivery.logs.amazonaws.com"
            }
            Action = [
                "s3:GetBucketAcl",
                "s3:ListBucket"
            ]
            Resource = "arn:aws:s3:::${var.flow_logs_bucket_name}"
            Condition = {
                StringEquals = {
                    "aws:SourceAccount" = data.aws_caller_identity.this.account_id
                },
                ArnLike = {
                    "aws:SourceArn" = "arn:aws:logs:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:*"
                }
            }
        }
    ]
    providers = {
        aws.current = aws.current
    }
}

resource "aws_flow_log" "this" {
    provider = aws.current
    log_destination = module.bucket.this.arn
    log_destination_type = "s3"
    traffic_type = "ALL"
    vpc_id = aws_vpc.this.id
    destination_options {
        file_format = "parquet"
        per_hour_partition = true
    }
}