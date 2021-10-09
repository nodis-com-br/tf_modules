resource "azurerm_public_ip" "lb" {
  count = var.type == "public" ? 1 : 0
  name = "${var.name}-lb"
  resource_group_name = var.rg.name
  location = var.rg.location
  allocation_method = "Static"
  sku = "Standard"
}

resource "azurerm_lb" "this" {
  name = "${var.rg.name}-${var.name}"
  resource_group_name = var.rg.name
  location = var.rg.location
  sku = "Standard"
  frontend_ip_configuration {
    name = var.name
    public_ip_address_id = var.type == "public" ? azurerm_public_ip.lb.0.id : null
    subnet_id = var.subnet.id
  }
}

resource "aws_route53_record" "this" {
  for_each = toset(var.domains)
  zone_id = var.route53_zone_id
  name = each.value
  type = "A"
  ttl = "300"
  records = [
    var.type == "public" ? azurerm_public_ip.lb.0.ip_address : azurerm_lb.this.private_ip_address
  ]
}


resource "azurerm_lb_probe" "this" {
  for_each = var.nat_rules
  resource_group_name = var.rg.name
  loadbalancer_id = azurerm_lb.this.id
  name = "${var.name}-${each.key}"
  protocol = each.value.protocol
  port = each.value.backend_port
}

resource "azurerm_lb_rule" "this" {
  for_each = var.nat_rules
  resource_group_name = var.rg.name
  loadbalancer_id = azurerm_lb.this.id
  name = "${var.name}-${each.key}"
  protocol = each.value.protocol
  frontend_port = each.value.frontend_port
  backend_port = each.value.backend_port
  frontend_ip_configuration_name = var.name
  backend_address_pool_id = azurerm_lb_backend_address_pool.this.id
  probe_id = azurerm_lb_probe.this[each.key].id
}

resource "azurerm_lb_backend_address_pool" "this" {
  name = var.name
  loadbalancer_id = azurerm_lb.this.id
  resource_group_name = null
}

resource "azurerm_network_interface_backend_address_pool_association" "this" {
  for_each = {for i, v in var.network_interfaces : i => v}
  backend_address_pool_id = azurerm_lb_backend_address_pool.this.id
  ip_configuration_name = "internal"
  network_interface_id = each.value.id
}
