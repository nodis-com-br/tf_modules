resource "azurerm_virtual_desktop_host_pool" "this" {
  location = var.rg.location
  resource_group_name = var.rg.name
  name = "${var.rg.name}-${var.name}"
  friendly_name = "${var.rg.name}-${var.name}"
  validate_environment = var.validate_environment
  start_vm_on_connect = var.start_vm_on_connect
  custom_rdp_properties = var.custom_rdp_properties
  type = var.type
  maximum_sessions_allowed = var.maximum_sessions_allowed
  load_balancer_type = var.load_balancer_type
}

resource "azurerm_virtual_desktop_workspace" "this" {
  location = var.rg.location
  resource_group_name = var.rg.name
  name = "${var.rg.name}-${var.name}"
}

resource "azurerm_virtual_desktop_application_group" "this" {
  location = var.rg.location
  resource_group_name = var.rg.name
  name = "${var.rg.name}-${var.name}"
  type = var.application_group_type
  host_pool_id = azurerm_virtual_desktop_host_pool.this.id
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "this" {
  workspace_id = azurerm_virtual_desktop_workspace.this.id
  application_group_id = azurerm_virtual_desktop_application_group.this.id
}

