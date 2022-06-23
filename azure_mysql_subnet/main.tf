resource "azurerm_subnet" "this" {
  name                 = var.name
  resource_group_name  = var.rg.name
  virtual_network_name = var.vnet.name
  address_prefixes     = [cidrsubnet(var.vnet.address_space[0], var.subnet_newbits, var.subnet_index)]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_private_dns_zone" "this" {
  name                = "${var.rg.name}.${var.subdomain}.mysql.database.azure.com"
  resource_group_name = var.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = var.name
  virtual_network_id    = var.vnet.id
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  resource_group_name   = azurerm_private_dns_zone.this.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "extra" {
  for_each = var.extra_virtual_network_links
  name = each.key
  virtual_network_id    = each.value
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  resource_group_name   = azurerm_private_dns_zone.this.resource_group_name
}