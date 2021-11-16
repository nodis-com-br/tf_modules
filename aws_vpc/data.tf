data "aws_availability_zones" "this" {
  provider = aws.current
  state = "available"
}