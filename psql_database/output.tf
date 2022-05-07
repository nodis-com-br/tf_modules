output "this" {
  value = postgresql_database.this
}

output "role_name" {
  value = try(postgresql_role.this[0].name, null)
}

output "password" {
  value = try(postgresql_role.this[0].password, null)
}