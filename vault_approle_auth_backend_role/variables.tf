variable "name" {}

variable "backend" {}

variable "policies" {
  default = []
}

variable "secret_id_bound_cidrs" {
  default = null
}