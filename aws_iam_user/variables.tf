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

variable "policy_statements" {
  default = {}
}

variable "policy_arns" {
  default = []
}

variable "assume_role_arns" {
  default = []
}