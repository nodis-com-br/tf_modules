variable "name" {}

variable "rg" {}

variable "storage" {
  type = number
  default = 5120
}

variable "backup_retention_days" {
  type = number
  default = 30
}

variable "auto_grow" {
  type = bool
  default = true
}

variable "admin_username" {
  type = string
  default = "postgres"
}

variable "psql_version" {
  type = number
  default = 11
}

variable "public_access" {
  type = bool
  default = false
}

variable "private_endpoint" {
  type = bool
  default = true
}

variable "subnet" {
  default = null
}

variable "sku_name" {}

variable "allowed_sources" {
  default = {}
  type = map(object({
    start_address = string
    end_address = string
  }))
}

variable "tags" {
  default = {}
}

variable "route53_zone_id" {}

variable "name_prefix" {
  default = "nodis"
}

variable "private_domain" {
  default = "azurepsql.nodis.com.br"
}

variable "vault_path" {
  default = "postgres"
}

variable "vault_admin_role_default_ttl" {
  default = 604800
}

variable "vault_role_name_prefix" {
  default = "vault"
}

variable "vault_initial_password" {
  default = "Mv9MUyX4Eh3gm4Mn"
  type = string
}

variable "vault_database_backends" {
  default = []
  type = list(string)
}