output "developer_role" {
  value = var.developer_role ? module.developer_role.0.this : null
}