### Resource group ####################

resource "azurerm_resource_group" "this" {
  name = var.name
  location = var.location
}

### Compute ###########################

resource "azurerm_ssh_public_key" "this" {
  name = var.name
  location = azurerm_resource_group.this.location
  resource_group_name = upper(azurerm_resource_group.this.name)
  public_key = var.ssh_master_key
}


### Storage ###########################

resource "azurerm_storage_account" "this" {
  name = "${var.storage_account_name_prefix}${var.name}"
  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location
  account_tier = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
}

### Load Balancer #####################



