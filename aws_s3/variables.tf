variable "name" {}

variable "role" {
  default = true
}

variable "role_owner_arn" {
  default = null
}

variable "save_metadata" {
  default = true
}

variable "vault_kv_path" {
  default = "secret/s3"
}