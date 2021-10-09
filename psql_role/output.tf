output "role" {
  value = postgresql_role.this
}

output "password" {
  sensitive = true
  value = random_password.this.0.result
}