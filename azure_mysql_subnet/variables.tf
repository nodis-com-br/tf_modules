variable "name" {}

variable "rg" {
  type = object({
    name = string
  })
}

variable "vnet" {
  type = object({
    name = string
    id = string
    address_space = list(string)
  })
}

variable "subnet_index" {}

variable "subnet_newbits" {
  type = number
  default = 6
}

variable "subdomain" {
  default = "example"
}

variable "extra_virtual_network_links" {
  default = {}
}