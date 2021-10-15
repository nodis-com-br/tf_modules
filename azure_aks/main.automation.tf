resource "azurerm_automation_account" "this" {
  name = "${var.rg.name}-${var.name}-automation"
  location = var.rg.location
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
  sku_name = "Basic"
  tags = {}
}


### Schedules

resource "azurerm_automation_schedule" "daily" {
  name = "${var.rg.name}-${var.name}-daily"
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
  automation_account_name = azurerm_automation_account.this.name
  frequency = "Week"
  interval = 1
  week_days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  lifecycle {
    ignore_changes = [
      start_time
    ]
  }
}


### Module update

resource "azurerm_automation_runbook" "update_modules" {
  name = "${var.rg.name}-${var.name}-update-modules"
  location = var.rg.location
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
  automation_account_name = azurerm_automation_account.this.name
  log_verbose = "true"
  log_progress = "true"
  runbook_type = "PowerShell"
  content = data.http.update_modules_script.body
  tags = {}
  lifecycle {
    ignore_changes = [
      content
    ]
  }
}

resource "azurerm_automation_job_schedule" "update_modules" {
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
  automation_account_name = azurerm_automation_account.this.name
  schedule_name = azurerm_automation_schedule.daily.name
  runbook_name = azurerm_automation_runbook.update_modules.name
  parameters = {
    resourcegroupname = azurerm_kubernetes_cluster.this.node_resource_group
    automationaccount = azurerm_automation_account.this.name
  }
}


### PVC Snapshots

resource "azurerm_automation_runbook" "pvc_snapshots" {
  name = "${var.name}-pvc-snapshots"
  location = var.rg.location
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
  automation_account_name = azurerm_automation_account.this.name
  log_verbose = "true"
  log_progress = "true"
  runbook_type = "PowerShell"
  content = data.local_file.pvc_snapshots.content
}

resource "azurerm_automation_job_schedule" "pvc_snapshots" {
  for_each = toset(var.snapshot_namespaces)
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
  automation_account_name = azurerm_automation_account.this.name
  schedule_name = azurerm_automation_schedule.daily.name
  runbook_name = azurerm_automation_runbook.pvc_snapshots.name
  parameters = {
    resourcegroupname = azurerm_kubernetes_cluster.this.node_resource_group
    namespace = each.value
  }
}