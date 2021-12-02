module "service_account" {
  source = "../gcp_service_account"
  account_id = "vault"
  account_key = true
  project = var.project
  roles = [
    "roles/editor",
  ]
}

resource "vault_gcp_secret_backend" "this" {
  credentials = base64decode(module.service_account.key.private_key)
  path = var.path
}

//resource "null_resource" "rotate_role_password" {
//  triggers = {
//    private_key = module.service_account.key.private_key
//  }
//  provisioner "local-exec" {
//    command = "VAULT_TOKEN=${data.vault_generic_secret.token.data.id} vault write -force ${var.path}/config/rotate-root"
//  }
//  depends_on = [
//    vault_gcp_secret_backend.this
//  ]
//}