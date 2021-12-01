variable "account_id" {}

variable "display_name" {
  default = null
}

variable "account_key" {
  default = false
}

variable "project" {
  default = null
}

variable "roles" {
  type = list(string)
  default = []
}