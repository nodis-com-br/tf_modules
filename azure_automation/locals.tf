locals {
  default_schedules = [
    "week_days",
    "daily"
  ]
  builtin_schedules = {
    week_days = {
      frequency = "Week"
      interval = 1
      week_days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    }
    daily = {
      frequency = "Week"
      interval = 1
      week_days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    }
  }
  builtin_runbooks = {
    update_modules = {
      log_verbose = "true"
      log_progress = "true"
      runbook_type = "PowerShell"
      content = data.http.update_modules_script.body
      schedule = "daily"
      parameters = {
        resourcegroupname = var.rg.name
      }
    }
    automated_snapshots = {
      log_verbose = "true"
      log_progress = "true"
      runbook_type = "PowerShell"
      content = file("scripts/snapshots.ps1")
      schedule = "week_days"
      parameters = {
        resourcegroupname = var.rg.name
        automationaccountname = azurerm_automation_account.this.name
      }
    }
  }
  selected_runbooks = {for r in var.builtin_runbooks : r => local.builtin_runbooks[r]}
  runbooks = merge(var.runbooks, local.selected_runbooks)
  selected_builtin_schedules = {for s in distinct(concat(local.default_schedules, var.builtin_schedules)) : s => local.builtin_schedules[s]}
  schedules = merge(var.schedules, local.selected_builtin_schedules)
}