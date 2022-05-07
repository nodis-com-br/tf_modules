output "developer_role_arn" {
  value = try(module.developer_role[0].this.arn, null)
}