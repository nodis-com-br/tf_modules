variable "name" {}

variable "backend" {}

variable "allowed_roles" {
  type = list(string)
  default = null
}

variable "role_name_prefix" {
  default = "vault"
}
