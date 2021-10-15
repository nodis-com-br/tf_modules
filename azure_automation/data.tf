data "local_file" "snapshots_script" {
  filename = "${path.module}/scripts/snapshots.ps1"
}

data "http" "update_modules_script" {
  url = "https://github.com/microsoft/AzureAutomation-Account-Modules-Update/raw/master/Update-AutomationAzureModulesForAccount.ps1"
}