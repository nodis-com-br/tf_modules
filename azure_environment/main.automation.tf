### Automation ########################

resource "azurerm_automation_account" "this" {
  name = "${var.name}-automation"
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku_name = "Basic"
}


# Schedules #######

resource "azurerm_automation_schedule" "week-days" {
  name = "${var.name}-week-days"
  resource_group_name = azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.this.name
  frequency = "Week"
  interval = 1
  start_time = null
  timezone = "Etc/UTC"
  week_days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
}

resource "azurerm_automation_schedule" "daily" {
  name = "${var.name}-daily"
  resource_group_name = azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.this.name
  frequency = "Week"
  interval = 1
  start_time = null
  timezone = "Etc/UTC"
  week_days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
}


# Module update ###

resource "azurerm_automation_runbook" "update_modules" {
  name = "${var.name}-update-modules"
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.this.name
  log_verbose = "true"
  log_progress = "true"
  runbook_type = "PowerShell"
  content = data.http.update_modules_script.body
  lifecycle {
    ignore_changes = [
      content
    ]
  }
}

resource "azurerm_automation_job_schedule" "update_modules" {
  resource_group_name = azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.this.name
  schedule_name = azurerm_automation_schedule.daily.name
  runbook_name = azurerm_automation_runbook.update_modules.name
  parameters = {
    resourcegroupname = azurerm_resource_group.this.name
    automationaccount = azurerm_automation_account.this.name
  }
}


# VM Snapshots ####

resource "azurerm_automation_runbook" "automated_snapshots" {
  name = "${var.name}-automated-snapshots"
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.this.name
  log_verbose = "true"
  log_progress = "true"
  runbook_type = "PowerShell"
  content = data.local_file.snapshots_script.content
}

resource "azurerm_automation_job_schedule" "automated_snapshots" {
  resource_group_name = azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.this.name
  schedule_name = azurerm_automation_schedule.week-days.name
  runbook_name = azurerm_automation_runbook.automated_snapshots.name
  parameters = {
    resourcegroupname = azurerm_resource_group.this.name
  }
}