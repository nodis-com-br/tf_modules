resource "azurerm_automation_account" "this" {
  name = "${var.name}-automation"
  location = var.rg.location
  resource_group_name = var.rg.name
  sku_name = "Basic"
}

resource "azurerm_automation_schedule" "this" {
  for_each = local.schedules
  name = "${var.name}-${each.key}"
  resource_group_name = var.rg.name
  automation_account_name = azurerm_automation_account.this.name
  frequency = each.value.frequency
  interval = each.value.interval
  week_days = each.value.week_days
}

resource "azurerm_automation_runbook" "this" {
  for_each = local.runbooks
  name = "${var.name}-${each.key}"
  resource_group_name = var.rg.name
  location = var.rg.location
  automation_account_name = azurerm_automation_account.this.name
  log_verbose = each.value.log_verbose
  log_progress = each.value.log_progress
  runbook_type = each.value.runbook_type
  content = each.value.content
  lifecycle {
    ignore_changes = [
      content
    ]
  }
}

resource "azurerm_automation_job_schedule" "this" {
  for_each = local.runbooks
  name = "${var.name}-${each.key}-${each.value.schedule}"
  automation_account_name = azurerm_automation_account.this.name
  schedule_name = each.value.schedule
  runbook_name = azurerm_automation_runbook.this[each.key].name
  parameters = {
    resourcegroupname = var.rg.name
    automationaccount = azurerm_automation_account.this.name
  }
}