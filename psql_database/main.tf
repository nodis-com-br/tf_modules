resource "postgresql_database" "this" {
  name = var.name
  lc_collate = var.lc_collate
}

resource "postgresql_role" "this" {
  name = var.name
  roles = []
  search_path = []
}

resource "postgresql_grant" "database" {
  database = postgresql_database.this.name
  role = postgresql_role.this.name
  schema = "public"
  object_type = "database"
  privileges = [
    "CONNECT",
    "CREATE",
    "TEMPORARY"
  ]
}

resource "postgresql_grant" "schema" {
  database = postgresql_database.this.name
  role = postgresql_role.this.name
  schema = "public"
  object_type = "schema"
  privileges = [
    "USAGE"
  ]
}

resource "postgresql_grant" "tables" {
  database = postgresql_database.this.name
  role = postgresql_role.this.name
  schema = "public"
  object_type = "table"
  privileges  = [
    "DELETE",
    "INSERT",
    "REFERENCES",
    "SELECT",
    "TRIGGER",
    "TRUNCATE",
    "UPDATE"
  ]
}

resource "postgresql_grant" "sequences" {
  database    = postgresql_database.this.name
  role        = postgresql_role.this.name
  schema      = "public"
  object_type = "sequence"
  privileges  = [
    "SELECT",
    "UPDATE",
    "USAGE"
  ]
}

resource "postgresql_grant" "functions" {
  database    = postgresql_database.this.name
  role        = postgresql_role.this.name
  schema      = "public"
  object_type = "function"
  privileges  = [
    "EXECUTE"
  ]
}
