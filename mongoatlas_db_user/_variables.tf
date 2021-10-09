variable "project" {}

variable "name" {}

variable "password" {}

variable "auth_database_name" {
  default = "admin"
}

variable "roles" {
  type = map(object({
    role_name = string
    database_name = string
  }))
}

