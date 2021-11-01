locals {
  modules = {
    AzureRM_Resources = {
      name = "AzureRM.Ressources"
      uri = ""
    }
  }
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
    }
    automated_snapshots = {
      log_verbose = "true"
      log_progress = "true"
      runbook_type = "PowerShell"
      content = data.local_file.snapshots_script.content
      schedule = "week_days"
    }
  }
  selected_runbooks = {for r in var.builtin_runbooks : r => local.builtin_runbooks[r]}
  runbooks = merge(var.runbooks, local.selected_runbooks)
  selected_builtin_schedules = {for s in distinct(concat(local.default_schedules, var.builtin_schedules)) : s => local.builtin_schedules[s]}
  schedules = merge(var.schedules, local.selected_builtin_schedules)
}