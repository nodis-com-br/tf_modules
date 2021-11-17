data "aws_availability_zones" "this" {
  provider = aws.current
  state = "available"
}

data "aws_region" "this" {
  provider = aws.current
}

data "aws_caller_identity" "this" {
  provider = aws.current
}