variable "name" {
  default = null
}

variable "assume_role_policy" {
  default = "iam_role"
}

variable "owner_arn" {
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