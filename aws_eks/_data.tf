data "aws_region" "current" {
  provider = aws.current
}

data "external" "thumbprint" {
  program = ["./modules/eks/oidc-thumbprint.sh", data.aws_region.current.name]
}

data "aws_eks_cluster_auth" "this" {
  provider = aws.current
  name = var.name
}

data "aws_autoscaling_groups" "this" {
  provider = aws.current
  filter {
    name   = "key"
    values = ["eks:cluster-name"]
  }
  filter {
    name   = "value"
    values = [var.name]
  }
}