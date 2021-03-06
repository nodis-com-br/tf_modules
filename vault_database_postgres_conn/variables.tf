variable "host" {}

variable "database" {}

variable "backend" {}

variable "verify_connection" {
  default = true
}

variable "allowed_roles" {
  type = list(string)
  default = null
}

variable "role_name_prefix" {
  default = "vault"
}

variable "login_name_suffix" {
  default = ""
}

variable "vault_token" {}