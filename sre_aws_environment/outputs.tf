output "developer_role" {
  value = try(module.developer_role[0].this, null)
}