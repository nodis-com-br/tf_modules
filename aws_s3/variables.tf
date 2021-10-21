variable "name" {}

variable "role" {
  default = false
}

variable "access_key" {
  default = false
}

variable "role_owner_arn" {
  default = null
}

variable "policy" {
  default = false
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