variable "vpc" {
  type = object({
    id = string
  })
}

variable "ingress_rules" {
  type = map(object({}))
  default = {}
}

variable "builtin_ingress_rules" {
  type = list(string)
  default = []
}

variable "egress_rules" {
  type = map(object({}))
  default = {}
}

variable "builtin_egress_rules" {
  type = list(string)
  default = []
}