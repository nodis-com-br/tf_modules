resource "mongodbatlas_database_user" "this" {
  project_id = var.project.id
  username = var.name
  password = var.password
  auth_database_name = var.auth_database_name
  dynamic "roles" {
    for_each = var.roles
    content {
      role_name = roles.value.role_name
      database_name = roles.value.database_name
    }
  }
  lifecycle {
    ignore_changes = [
      password
    ]
  }
}