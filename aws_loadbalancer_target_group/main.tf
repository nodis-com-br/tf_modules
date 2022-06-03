resource "aws_alb_target_group" "this" {
  provider = aws.current
  port = var.port
  protocol = var.protocol
  vpc_id = var.vpc.id
  target_type = var.target_type
  health_check {
    path = var.health_check.path
    matcher = var.health_check.matcher
  }
}

resource "aws_alb_target_group_attachment" "this" {
  provider = aws.current
  for_each = {for t in var.targets : t.id => {id = t.id}}
  target_group_arn = aws_alb_target_group.this.arn
  target_id = each.value.id
}

