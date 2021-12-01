variable "name" {}

variable "backend" {}

variable "secret_type" {
  default = "service_account_key"
}

variable "project" {}

variable "roles" {
  type = list(string)
}