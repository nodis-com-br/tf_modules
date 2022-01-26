variable "name" {}

variable "command" {}

variable "sha256" {}

variable "args" {
  default = []
}

variable "type" {
  default = "secret"
}