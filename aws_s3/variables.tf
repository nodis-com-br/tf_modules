variable "name" {}

variable "force_destroy" {
  default = false
}

variable "acl" {
  default = "private"
}

variable "versioning" {
  default = "Suspended"
}

variable "bucket_policy_statements" {
  default = []
}

variable "server_side_encryption" {
  default = {
    kms_master_key_id = null
    sse_algorithm = "AES256"
  }
}

variable "create_policy" {
  default = false
}

variable "create_role" {
  default = false
}

variable "role_owner_arn" {
  default = null
}

variable "vault_backend" {
  default = null
}

variable "vault_role" {
  default = null
}

variable "vault_credential_type" {
  default = null
}
