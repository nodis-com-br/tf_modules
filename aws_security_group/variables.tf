variable "vpc" {
  type = object({
    id = string
  })
}

variable "ingress_rules" {
  default = {}
}

variable "builtin_ingress_rules" {
  type = list(string)
  default = []
}

variable "egress_rules" {
  default = {}
}

variable "builtin_egress_rules" {
  type = list(string)
  default = []
}