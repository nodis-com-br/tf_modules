variable "username" {}


variable "access_key" {
  default = false
}

variable "console" {
  default = false
}

variable "pgp_key" {
  default = null
}

variable "policies" {
  default = {}
}

variable "builtin_policies" {
  default = []
}

variable "policy_arns" {
  default = []
}

variable "builtin_policy_arns" {
  default = []
}