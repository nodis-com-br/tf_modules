variable "name" {}

variable "backend" {}

variable "project_id" {}

variable "private_key" {}

variable "public_key" {}

variable "allowed_roles" {
  type = list(string)
  default = null
}