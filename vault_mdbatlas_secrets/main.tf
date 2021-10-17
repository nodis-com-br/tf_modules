module "vault_mount" {
  source = "../vault_mount"
  path = "mongodbatlas"
  type = "mongodbatlas"
}

resource "vault_generic_endpoint" "mongodbatlas_secret_backend_config" {
  depends_on = [
    module.vault_mount.backend
  ]
  path = "${module.vault_mount.backend.path}/config"
  ignore_absent_fields = true
  data_json = jsonencode(var.config)
}
