variable "owner_arn" {}

variable "name" {
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

variable "vault_kv_path" {
  default = null
}