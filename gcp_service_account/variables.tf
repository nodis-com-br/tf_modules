variable "account_id" {}

variable "display_name" {
  default = null
}

variable "project" {
  default = null
}

variable "roles" {
  type = list(string)
  default = []
}