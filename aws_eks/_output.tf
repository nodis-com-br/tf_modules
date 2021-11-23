output "cluster" {
  value = aws_eks_cluster.this
}

output "service_accounts" {
  value = aws_iam_role.sa
}

output "auth" {
  value = data.aws_eks_cluster_auth.this
  sensitive = true
}

output "autoscaling_groups" {
  value = data.aws_autoscaling_groups.this
}