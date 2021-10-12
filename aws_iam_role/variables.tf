variable "owner_arn" {}

variable "name" {
  default = null
}

variable "policies" {
  default = {}
}

variable "policy_arns" {
  type = list(string)
  default = []
}