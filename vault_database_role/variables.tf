variable "name" {}

variable "backend" {}

variable "db_name" {}

variable "creation_statements" {
  type = list(string)
}

variable "default_ttl" {
  default = null
}

variable "max_ttl" {
  default = null
}