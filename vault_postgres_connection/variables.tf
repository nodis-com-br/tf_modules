variable "host" {}

variable "database" {}

variable "backend" {}

variable "allowed_roles" {
  type = list(string)
  default = []
}

variable "role_name_prefix" {
  default = "vault"
}

variable "login_name_suffix" {
  default = ""
}
