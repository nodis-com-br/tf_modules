module "bucket" {
  source = "../aws_s3"
  name = var.bucket
  policy = true
  role = false
  providers = {
    aws.current = aws.current
  }
}


module "certificate" {
  source = "../aws_acm_certificate"
  domain_name = var.domain
  subject_alternative_names = var.alternative_domain_names
  route53_zone = var.route53_zone
  providers = {
    aws.current = aws.current
    aws.dns = aws.dns
  }
}

//resource "aws_cloudfront_distribution" "this" {
//  provider = aws.current
//  enabled = var.cloudfront_enabled
//  default_root_object = var.default_root_object
//  is_ipv6_enabled = true
////  aliases = concat([var.domain], var.alternative_domain_names)
//  custom_error_response {
//    error_caching_min_ttl = 60
//    error_code = 403
//    response_code = 200
//    response_page_path = "/${var.default_root_object}"
//  }
//  default_cache_behavior {
//    allowed_methods = ["GET", "HEAD"]
//    cached_methods =  ["GET", "HEAD"]
//    default_ttl = 0
//    max_ttl = 0
//    min_ttl = 0
//    target_origin_id = "s3-${module.bucket.this.bucket}"
//    viewer_protocol_policy = "redirect-to-https"
//    forwarded_values {
//      headers = []
//      query_string = false
//      query_string_cache_keys = []
//      cookies {
//        forward = "none"
//        whitelisted_names = []
//      }
//    }
//  }
//  origin {
//    origin_path = var.origin_path
//    domain_name = module.bucket.this.bucket_domain_name
//    origin_id = "s3-${module.bucket.this.bucket}"
//  }
//  restrictions {
//    geo_restriction {
//      locations        = []
//      restriction_type = "none"
//    }
//  }
//  viewer_certificate {
//    cloudfront_default_certificate = true
////    acm_certificate_arn = module.certificate.this.arn
//    minimum_protocol_version = "TLSv1.2_2019"
//    ssl_support_method = "sni-only"
//  }
//}

//resource "aws_iam_policy" "this" {
//  provider = aws.current
//  name = var.name
//  policy = jsonencode({
//    Version = "2012-10-17"
//    Statement = [
//      {
//        Effect = "Allow"
//        Action = [
//          "cloudfront:CreateInvalidation"
//        ]
//        Resource = [
//          aws_cloudfront_distribution.this.arn
//        ]
//      }
//    ]
//  })
//}

//module "dns_record" {
//  source = "../aws_route53_record"
//  name = var.domain
//  route53_zone = var.route53_zone
//  type = "CNAME"
//  records = [
//    aws_cloudfront_distribution.this.domain_name
//  ]
//  providers = {
//    aws.current = aws.dns
//  }
//}