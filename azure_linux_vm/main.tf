resource "azurerm_availability_set" "this" {
  count = var.high_avaliability ? 1 : 0
  name = "${var.rg.name}-${var.name}"
  resource_group_name = var.rg.name
  location = var.rg.location
  managed = true
}

resource "azurerm_linux_virtual_machine" "this" {
  count = var.host_count
  name = "${var.rg.name}-${var.name}${format("%04.0f", count.index + 1)}"
  location = var.rg.location
  resource_group_name = var.rg.name
  size = var.size
  admin_username = "nodis"
  availability_set_id = try(azurerm_availability_set.this.0.id, null)
  network_interface_ids = [
    azurerm_network_interface.this[count.index].id
  ]
  source_image_id = var.source_image_id
  admin_ssh_key {
    username = var.admin_username
    public_key = var.ssh_key
  }
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_account.primary_blob_endpoint
  }
  dynamic "source_image_reference" {
    for_each = local.source_image_reference
    content {
      publisher = source_image_reference.value.publisher
      offer = source_image_reference.value.offer
      sku = source_image_reference.value.sku
      version = source_image_reference.value.version
    }
  }
  dynamic "plan" {
    for_each = local.plan
    content {
      name = plan.value.name
      product = plan.value.product
      publisher = plan.value.publisher
    }
  }
  tags = local.tags
}

resource "azurerm_managed_disk" "this" {
  for_each = local.extra_disks
  name  = each.value.fullname
  location = var.rg.location
  resource_group_name = var.rg.name
  storage_account_type = each.value.storage_account_type
  create_option = "Empty"
  disk_size_gb = each.value.disk_size_gb

}

resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each = local.extra_disks
  managed_disk_id = azurerm_managed_disk.this[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.this[each.value.host_index].id
  lun = 10 + index(keys(var.extra_disks), each.value.basename)
  caching = "ReadWrite"
}