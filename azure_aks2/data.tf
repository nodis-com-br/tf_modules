data "azurerm_public_ip" "outbound" {
  name = local.outbound_public_ip_id_name
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
}