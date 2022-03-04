output "developer_role" {
  value = var.developer_role ? module.developer_role.this : null
}