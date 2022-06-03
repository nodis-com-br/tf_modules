data "aws_caller_identity" "current" {
  provider = aws.current
}

data "aws_region" "current" {
  provider = aws.current
}