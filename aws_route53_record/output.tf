output "this" {
  value = try(aws_route53_record.this[0], aws_route53_record.alias[0])
}