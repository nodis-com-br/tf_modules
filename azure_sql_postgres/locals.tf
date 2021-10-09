locals {
  name = "${var.name_prefix}-${var.rg.name}-${var.name}"
  short_name = "${var.rg.name}-${var.name}"
}