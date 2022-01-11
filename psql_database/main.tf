resource "postgresql_database" "this" {
  provider = postgresql
  name = var.name
  lc_collate = var.lc_collate
}

resource "random_password" "this" {
  count = var.create_role ? 1 : 0
  length  = 16
  special = false
}

resource "postgresql_role" "this" {
  provider = postgresql
  count = var.create_role ? 1 : 0
  name = var.name
  login = true
  password = random_password.this.0.result
  roles = []
  search_path = []
}

resource "postgresql_grant" "database" {
  provider = postgresql
  count = var.create_role ? 1 : 0
  database = postgresql_database.this.name
  role = postgresql_role.this.0.name
  schema = "public"
  object_type = "database"
  privileges = [
    "CONNECT",
    "CREATE",
    "TEMPORARY"
  ]
  lifecycle {
    ignore_changes = [
      privileges
    ]
  }
}

resource "postgresql_grant" "schema" {
  provider = postgresql
  count = var.create_role ? 1 : 0
  database = postgresql_database.this.name
  role = postgresql_role.this.0.name
  schema = "public"
  object_type = "schema"
  privileges = [
    "USAGE"
  ]
  lifecycle {
    ignore_changes = [
      privileges
    ]
  }
}

resource "postgresql_grant" "tables" {
  provider = postgresql
  count = var.create_role ? 1 : 0
  database = postgresql_database.this.name
  role = postgresql_role.this.0.name
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
  lifecycle {
    ignore_changes = [
      privileges
    ]
  }
}

resource "postgresql_grant" "sequences" {
  provider = postgresql
  count = var.create_role ? 1 : 0
  database = postgresql_database.this.name
  role  = postgresql_role.this.0.name
  schema = "public"
  object_type = "sequence"
  privileges  = [
    "SELECT",
    "UPDATE",
    "USAGE"
  ]
  lifecycle {
    ignore_changes = [
      privileges
    ]
  }
}

resource "postgresql_grant" "functions" {
  provider = postgresql
  count = var.create_role ? 1 : 0
  database = postgresql_database.this.name
  role = postgresql_role.this.0.name
  schema = "public"
  object_type = "function"
  privileges  = [
    "EXECUTE"
  ]
  lifecycle {
    ignore_changes = [
      privileges
    ]
  }
}
