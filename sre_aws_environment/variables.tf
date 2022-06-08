variable "name" {}

variable "account_id" {}

variable "bucket_name_prefix" {
  default = "nodis"
}

variable "role_owner_arn" {
  default = null
  type = string
}

variable "developer_role" {
  default = false
  type = bool
}

variable "developer_role_policy_arns" {
  default = []
  type = list(string)
}

variable "save_role_arns" {
  default = true
}

variable "vault_kv_path" {
  default = null
}