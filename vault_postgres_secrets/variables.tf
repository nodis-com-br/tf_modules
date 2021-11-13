variable "name" {}


variable "instace_name" {
  default = null
}

variable "instace_addr" {}

variable "database" {
  default = "postgres"
}

variable "role_name_prefix" {
  default = "vault"
}

variable "role_initial_password" {
  default = "Mv9MUyX4Eh3gm4Mn"
  type = string
}

variable "backend_path" {
  default = "postgres"
}