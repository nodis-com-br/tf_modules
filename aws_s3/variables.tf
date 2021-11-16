variable "name" {}

variable "acl" {
  default = "private"
}

variable "bucket_policy_statements" {
  type = list(string)
  default = []
}

variable "extra_bucket_policy_statements" {
  default = []
}

variable "server_side_encryption" {
  default = {
    kms_master_key_id = null
    sse_algorithm = "AES256"
  }
}

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

