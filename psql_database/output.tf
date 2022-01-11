output "password" {
  value = var.create_role ? random_password.this.0.result : null
}