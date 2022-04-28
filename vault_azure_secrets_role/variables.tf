variable "name" {}

variable "backend" {}

variable "ttl" {
  default = null
}

variable "max_ttl" {
  default = null
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