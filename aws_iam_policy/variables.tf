variable "name" {
  default = null
}

variable "policy" {
  default = null
}

variable "assume_role_arns" {
  default = []
  type = list(string)
}