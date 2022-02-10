variable "name" {}

variable "rg" {
  type = object({
    name = string
    location = string
  })
}

variable vnet {
  type = object({
    id = string
  })
}

variable "subnet" {
  type = object({
    id = string
    name = string
  })
}

variable "default" {
  default = true
}

variable "default_node_pool_name" {
  default = "default"
}

variable "default_node_pool_class" {
  default = null
}

variable "default_node_pool_node_count" {
  default = 1
}

variable "default_node_pool_min_count" {
  default = null
}

variable "default_node_pool_max_count" {
  default = null
}

variable "default_pool_node_size" {
  default = "standard_ds2_v2"
}

variable "default_node_pool_enable_auto_scaling" {
  default = false
}

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

variable "snapshot_namespaces" {
  type = list(string)
  default = []
}

variable "kubernetes_version" {
  type = string
  default = "1.20.5"
}

variable "automatic_channel_upgrade" {
  default = "stable"
}

variable "private_cluster_enabled" {
  default = false
}

variable "private_dns_linked_vnets" {
  default = {}
  type = map(object({
    id = string
  }))
}

variable "vault_auth_backend" {
  type = bool
  default = false
}

variable "vault_secrets_backend" {
  type = bool
  default = false
}

variable "vault_secrets_backend_path" {
  default = "kubernetes/"
}

variable "vault_token_reviewer_sa" {
  default = {
    name = "vault-injector"
    namespace = "vault-injector"
  }
}

variable "private_cluster_public_fqdn_enabled" {
  default = false
}

variable "api_server_authorized_ip_ranges" {
  default = null
}

variable "custom_resource_definitions" {
  default = []
  type = list(string)
}