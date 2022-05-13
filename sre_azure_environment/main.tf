resource "azurerm_resource_group" "this" {
  name = var.name
  location = var.location
}

resource "azurerm_ssh_public_key" "this" {
  name = var.name
  location = azurerm_resource_group.this.location
  resource_group_name = upper(azurerm_resource_group.this.name)
  public_key = var.ssh_master_key
}

resource "azurerm_storage_account" "this" {
  name = "${var.storage_account_name_prefix}${var.name}"
  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location
  account_tier = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  queue_encryption_key_type = var.queue_encryption_key_type
  table_encryption_key_type = var.table_encryption_key_type
  infrastructure_encryption_enabled = true
}

module "automation_account" {
  count = var.enable_automation ? 1 : 0
  source = "../azure_automation"
  name = var.name
  rg = azurerm_resource_group.this
  builtin_runbooks = var.automation_builtin_runbooks
}



