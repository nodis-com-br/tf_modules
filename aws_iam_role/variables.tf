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

variable "builtin_policies" {
  default = []
}

variable "save_role" {
  default = true
}

variable "vault_kv_path" {
  default = "secret/aws/role"
}