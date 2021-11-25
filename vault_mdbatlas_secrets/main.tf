module "vault_mount" {
  source = "../vault_mount"
  path = "mongodbatlas"
  type = "mongodbatlas"
}

resource "vault_generic_endpoint" "mongodbatlas_secret_backend_config" {
  count = var.config == null ? 0 : 1
  depends_on = [
    module.vault_mount.this
  ]
  path = "${module.vault_mount.this.path}/config"
  ignore_absent_fields = true
  data_json = jsonencode(var.config)
}
