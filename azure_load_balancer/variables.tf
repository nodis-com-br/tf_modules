variable "name" {}

variable "rg" {}

variable "type" {}

variable "subnet" {
  default = null
}

variable "domains" {
  type = list(string)
}

variable "network_interfaces" {
  type = list(object({
    name = string
    id = string
  }))
}

variable "nat_rules" {
  type = map(object({
    protocol = string
    frontend_port = string
    backend_port = string
  }))
}

variable "route53_zone" {
  default = null
}
