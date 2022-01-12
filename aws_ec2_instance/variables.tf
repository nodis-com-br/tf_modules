variable "name" {}

variable account {}

variable "host_count" {
  default = 1
}

variable "ami" {}

variable "type" {
  default = "t3a.micro"
}

variable "key_name" {}

variable "vpc" {
  type = object({
    id = string
  })
}

variable "subnets" {
  type = list(object({
    id = string
  }))
}

variable "root_volume" {
  default = {
    volume_type = "gp2"
    volume_size = 20
    delete_on_termination = true
  }
}

variable "tags" {}

variable source_dest_check {
  default = "true"
}

variable "ingress_rules" {
  default = {}
  type = map(object({
    security_groups = list(string)
    protocol = string
    from_port = number
    to_port = number
    cidr_blocks = list(string)
  }))
}

variable "builtin_ingress_rules" {
  default = []
}

variable "egress_rules" {
  default = {}
  type = map(object({
    security_groups = list(string)
    protocol = string
    from_port = number
    to_port = number
    cidr_blocks = list(string)
  }))
}

variable "builtin_egress_rules" {
  default = ["all"]
}

variable "route53_zone" {
  type = object({
    name = string
    id = string
  })
}

variable "private_domain" {
  default = "awsvm.nodis.com.br"
}

variable "instance_role" {
  default = false
}

variable "instance_role_policies" {
  default = {}
}

variable "fixed_public_ip" {
  default = false
}

variable "domain" {
  default = null
}