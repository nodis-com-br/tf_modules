module "vault_mount" {
  source = "../vault_mount"
  path = var.path
  type = var.type
}

resource "vault_generic_endpoint" "config" {
  path = "${module.vault_mount.this.path}/config"
  ignore_absent_fields = true
  disable_read = true
  data_json = jsonencode({
    app_id = var.app_id
    org_name = var.org_name
    prv_key = var.private_key
  })
}
