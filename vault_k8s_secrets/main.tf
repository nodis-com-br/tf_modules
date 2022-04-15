module "vault_mount"{
  source = "../vault_mount"
  path = var.path
  type = var.type
}

resource "vault_generic_endpoint" "config" {
  path = "${module.vault_mount.this.path}/config"
  ignore_absent_fields = true
  disable_read = true
  disable_delete = true
  data_json = jsonencode({
    host = var.host
    jwt = var.jwt
    ca_cert = var.ca_cert
    admin_role = var.admin_role
    editor_role = var.editor_role
    viewer_role = var.viewer_role
    max_ttl = var.max_ttl
  })
}
