variable "name" {}

variable "backend" {}

variable "organization_id" {}

variable "database_name" {
  default = null
}

variable "ip_addresses" {
  default = []
}

variable "cidr_blocks" {
  default = []
}

variable "roles" {
  default = []
}

variable "ttl" {
  default = null
}

variable "max_ttl" {
  default = null
}