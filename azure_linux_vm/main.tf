# Networking

resource "azurerm_public_ip" "this" {
  count = var.public_access ? var.host_count : 0
  name = "${var.rg.name}-${var.name}${format("%04.0f", count.index + 1)}"
  resource_group_name = var.rg.name
  location = var.rg.location
  sku = "Standard"
  allocation_method = "Static"
  zones = [1, 2, 3]
}

resource "azurerm_network_interface" "this" {
  count = var.host_count
  name = "${var.rg.name}-${var.name}${format("%04.0f", count.index + 1)}"
  location = var.rg.location
  resource_group_name = var.rg.name
  ip_configuration {
    name = "internal"
    subnet_id = var.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = try(azurerm_public_ip.this[count.index].id, null)
  }
}

resource "azurerm_network_security_group" "this" {
  name = "${var.rg.name}-${var.name}"
  resource_group_name = var.rg.name
  location = var.rg.location
}

resource "azurerm_network_security_rule" "this" {
  for_each = var.ingress_rules
  name = "${var.rg.name}-${var.name}-${each.key}"
  resource_group_name = var.rg.name
  network_security_group_name = azurerm_network_security_group.this.name
  priority = 100 + index(keys(var.ingress_rules), each.key)
  direction = "Inbound"
  access = "Allow"
  protocol = each.value.protocol
  source_port_range = try(each.value.source_port_range, "*")
  destination_port_range = try(each.value.destination_port_range, "*")
  source_address_prefix = try(each.value.source_address_prefix, "*")
  destination_address_prefix = "*"
}

resource "azurerm_network_interface_security_group_association" "this" {
  count = var.host_count
  network_interface_id = azurerm_network_interface.this[count.index].id
  network_security_group_id = azurerm_network_security_group.this.id
}


# Virtual Machine

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
  admin_username = var.admin_username
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
  identity {
    type = var.identity_type
    identity_ids = var.identity_ids
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

# DNS

module "private_dns_record" {
  source = "../aws_route53_record"
  count = var.host_count
  name = "${var.rg.name}-${var.name}${format("%04.0f", count.index + 1)}.${var.private_domain}"
  route53_zone = var.route53_zone
  records = [
    azurerm_network_interface.this[count.index].private_ip_address
  ]
  providers = {
    aws.current = aws.dns
  }
}

//resource "aws_route53_record" "private" {
//
//  zone_id = _zone_id
//  name = "${var.rg.name}-${var.name}${format("%04.0f", count.index + 1)}.${var.private_domain}"
//  type = "A"
//  ttl = "300"
//  records = [
//    azurerm_network_interface.this[count.index].private_ip_address
//  ]
//}

module "public_dns_record" {
  source = "../aws_route53_record"
  count = var.domain == null ? 0 : 1
  name = var.domain
  route53_zone = var.route53_zone
  records = [for ip in azurerm_public_ip.this : ip.ip_address]
  providers = {
    aws.current = aws.dns
  }
}

//resource "aws_route53_record" "public" {
//  count = var.domain == null ? 0 : 1
//  zone_id = var.route53_zone_id
//  name = var.domain
//  type = "A"
//  ttl = "300"
//  records = [for ip in azurerm_public_ip.this : ip.ip_address]
//}