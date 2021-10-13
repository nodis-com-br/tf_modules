data "local_file" "pvc_snapshots" {
  filename = "${path.module}/scripts/pvc_snapshots.ps1"
}

data "local_file" "tunnelfront-patch" {
  filename = "${path.module}/patchs/tunnelfront-patch.yaml"
}

data "http" "update_modules_script" {
  url = "https://github.com/microsoft/AzureAutomation-Account-Modules-Update/raw/master/Update-AutomationAzureModulesForAccount.ps1"
}

data "kubernetes_service_account" "vault-injector" {
  count = var.vault_auth_backend ? 1 : 0
  metadata {
    name = var.vault_token_reviewer_sa.name
    namespace = var.vault_token_reviewer_sa.namespace
  }
}

data "kubernetes_secret" "vault-injector-token" {
  count = var.vault_auth_backend ? 1 : 0
  metadata {
    name = data.kubernetes_service_account.vault-injector.0.default_secret_name
    namespace = var.vault_token_reviewer_sa.namespace
  }
}

data "dns_a_record_set" "endpoint_ip" {
  host = trimprefix(trimsuffix(azurerm_kubernetes_cluster.this.kube_config.0.host, ":443"), "https://")
}