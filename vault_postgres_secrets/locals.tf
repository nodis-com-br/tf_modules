locals {
  username = var.instance_name == null ? postgresql_role.this.name : "${postgresql_role.this.name}@${var.instance_name}"
}