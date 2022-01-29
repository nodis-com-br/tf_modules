variable "name" {}

variable "engine" {}

variable "engine_version" {}

variable "vpc_id" {}

variable "subnet_id_list" {}

variable "username" {}

variable "password" {}

variable "port" {}

variable "instance_class" {}

variable "allocated_storage" {}

variable "max_storage" {}

variable "deletion_protection" {}

variable "public_accessible" {
  default = false
}

variable "performance_insights_enabled" {
  default = true
}

variable "dns_record" {
  default = null
  type = object({
    hostname = string
    zone = object({
      id = string
    })
  })
}

variable "ingress_rules" {
  type = map(object({
    protocol = string
    from_port = number
    to_port = number
    cidr_blocks = list(string)
    ipv6_cidr_blocks = list(string)
  }))
}

variable "egress_rules" {
  type = map(object({
    protocol = string
    from_port = number
    to_port = number
    cidr_blocks = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  default = {
    all = {
      protocol = -1
      from_port = 0
      to_port = 0
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      ipv6_cidr_blocks = [
        "::/0"
      ]
    }
  }
}

variable "tags" {}