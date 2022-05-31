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

variable "ssl_enforcement_enabled" {
  default = true
}
variable "ssl_minimal_tls_version_enforced" {
  default = "TLS1_2"
}

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