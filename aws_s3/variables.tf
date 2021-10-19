variable "name" {}

variable "role" {
  default = true
}

variable "access_key" {
  default = false
}

variable "role_owner_arn" {
  default = null
}

variable "save_policy_arn" {
  default = true
}

variable "save_role_arn" {
  default = true
}

variable "vault_kv_path" {
  default = null
}