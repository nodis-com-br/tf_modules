resource "postgresql_role" "root" {
  name = "postgres@${var.instance}"
}

resource "postgresql_grant_role" "grant_root" {
  role = "postgres"
  grant_role = postgresql_role.root.name
  with_admin_option = true
}