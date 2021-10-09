variable "name" {}

variable "backend" {}

variable "ttl" {
  default = 300
}

variable "max_ttl" {
  default = 604800
}

variable "application_object_id" {
  default = null
}

variable "groups" {
  default = []
}

variable "roles" {
  default = []
}