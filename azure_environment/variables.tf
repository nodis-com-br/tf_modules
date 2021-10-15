variable "name" {}

variable "location" {}

variable "address_space" {}

variable "subnet_newbits" {
  type = number
  default = 6
}

variable "subnets" {
  type = number
  default = 1
}

variable "vpn_gateway" {
  type = bool
  default = false
}

variable "gateway_subnet_index" {
  type = number
  default = 63
}

variable "ssh_master_key" {}

variable "peering_connections" {
  default = {}
  type = map(object({
    id = string
  }))
}

variable "associate_nat_gateway" {
  type = bool
  default = true
}

variable "network_security_rules" {
  default = {}
}

variable "storage_account_name_prefix" {
  default = "nodis"
}

variable "storage_account_tier" {
  default = "Standard"
}

variable "storage_account_replication_type" {
  default = "GRS"
}

variable "vnet_dns_servers" {
  default = []
}

variable "automation_builtin_runbooks" {
  default = []
}