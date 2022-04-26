variable "name" {}

variable "host" {}

variable "database" {
  default = "postgres"
}

variable "role_name_prefix" {
  default = "vault"
}

variable "backend_path" {
  default = "postgres"
}

variable "login_name_suffix" {
  default = ""
}

variable "allowed_roles" {
  type = list(string)
  default = []
}