locals {
  username = var.instace_name == null ? postgresql_role.this.name : "${postgresql_role.this.name}@${var.instace_name}"
}