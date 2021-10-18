variable "name" {}

variable "role" {
  default = true
}

variable "users_iam_root_arn" {
  default = null
}

variable "save_metadata" {
  default = false
}

variable "vault_kv_path" {
  default = "secret/s3"
}