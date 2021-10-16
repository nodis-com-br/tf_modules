variable "username" {}

variable "policy_arns" {
  default = []
}

variable "policies" {
  default = {}
}

variable "pgp_key" {
  default = null
}

variable "console" {
  default = false
}

variable "access_key" {
  default = false
}