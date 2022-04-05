variable "org" {}

variable "name" {}

variable "ip_access_list" {
  default = {}
}

variable "allowed_roles" {
  default = ["*"]
}

variable "root_rotation_statements" {
  default = []
}

variable "vault_path" {
  default = "mongodb"
}

variable "vault_secret_backend_credentials" {
  default = null
}

variable "vault_secret_backend_config_name" {
  default = null
}

variable "vault_admin_role_default_ttl" {
  default = 604800
}