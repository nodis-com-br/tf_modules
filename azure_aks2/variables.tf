variable "name" {}

variable "rg" {
  type = object({
    name = string
    location = string
  })
}

variable vnet_id {
  default = null
}

variable "kubernetes_version" {}

variable "automatic_channel_upgrade" {
  default = "stable"
}

variable "private_cluster_enabled" {
  default = true
}

variable "private_cluster_public_fqdn_enabled" {
  default = true
}

variable "api_server_authorized_ip_ranges" {
  default = null
}

variable "role_based_access_control_enabled" {
  default = true
  type = bool
}

variable "network_outbound_type" {
  default = "loadBalancer"
}

# Nodes #######################################################################

variable "node_admin_username" {
  type = string
  default = "nodis"
}

variable "node_admin_ssh_key" {
  type = string
}

variable "node_pools" {
  default = {}
}

# Default node pool ###########################################################

variable "default_node_pool_name" {
  default = "pool0001"
}

variable "default_node_pool_class" {
  default = "general"
}

variable "default_node_pool_node_count" {
  default = null
}

variable "default_node_pool_min_count" {
  default = 1
}

variable "default_node_pool_max_count" {
  default = null
}

variable "default_node_pool_vm_size" {
  default = "standard_ds2_v2"
}

variable "default_node_pool_enable_auto_scaling" {
  default = true
}

variable "default_node_pool_subnet_id" {
  default = null
}
