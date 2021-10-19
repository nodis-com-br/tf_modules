locals {
  vault_kv_path = var.vault_kv_path == null ? module.defaults.aws.vault_kv_path : var.vault_kv_path
}