variable "rg" {
  type = object({
    name = string
    location = string
  })
}

variable vnet {
  default = {id = null}
  type = object({
    id = string
  })
}

variable "name" {}


variable "node_admin_username" {
  type = string
  default = "nodis"
}

variable "node_admin_ssh_key" {
  type = string
}

variable "kubernetes_version" {
  type = string
  default = "1.20.5"
}

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

variable "node_pools" {
  default = {}
}


variable "default_node_pool_name" {
  default = "pool0001"
}

variable "default_node_pool_class" {
  default = "general"
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

variable "default_node_pool_vm_size" {
  default = "standard_ds2_v2"
}

variable "default_node_pool_enable_auto_scaling" {
  default = true
}

variable "domain" {
  default = "nodis.com.br"
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
