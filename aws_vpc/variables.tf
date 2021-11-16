variable "account" {}

variable "name" {}

variable "ipv4_cidr" {}

variable "subnet_newbits" {}

variable "subnet_tags" {
  default = {}
}

variable "public" {
  default = true
}

variable "private" {
  default = true
}

variable "peering_requests" {
  default = {}
  type = map(object({
    account_id = string
    vpc = object({
      id = string
      cidr_block = string
    })
  }))
}

variable "peering_accepters" {
  default = {}
  type = map(object({
    peering_request = object({
      id = string
    })
    vpc = object({
      id = string
      cidr_block = string
    })
  }))
}

variable "vpn_connections" {
  default = {}
}