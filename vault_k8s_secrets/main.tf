module "service_account" {
  source = "../kubernetes_service_account"
  name = var.service_account_name
  namespace = "kube-system"
  cluster_role_rules = var.service_account_ruleset
  providers = {
    kubernetes = kubernetes
  }
}

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
    ca_cert = module.service_account.ca_crt
    jwt = module.service_account.token
    admin_role = var.admin_role
    editor_role = var.editor_role
    viewer_role = var.viewer_role
    default_ttl = var.default_ttl
    max_ttl = var.max_ttl
  })
}
