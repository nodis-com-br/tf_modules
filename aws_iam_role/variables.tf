variable "owner_arn" {}

variable "name" {
  default = null
}

variable "policies" {
  default = {}
}

variable "policy_arns" {
  type = map(object({
    arn = string
  }))
  default = {}
}