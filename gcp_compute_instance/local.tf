locals {
  name = "${var.name}${format("%04.0f", count.index + 1)}"
  hostname = var.hostname == null ? local.name : var.hostname
}