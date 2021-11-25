resource "aws_route53_zone" "this" {
  provider = aws.current
  name = var.domain
}

module "root_record" {
  source = "../aws_route53_record"
  for_each = var.root_records
  name = var.domain
  route53_zone = aws_route53_zone.this
  type = each.key
  records = each.value
  providers = {
    aws.current = aws.current
  }
}