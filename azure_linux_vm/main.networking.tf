resource "azurerm_public_ip" "this" {
  count = var.public_access ? var.host_count : 0
  name = "${var.rg.name}-${var.name}${format("%04.0f", count.index + 1)}"
  resource_group_name = var.rg.name
  location = var.rg.location
  sku = "Standard"
  allocation_method = "Static"
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