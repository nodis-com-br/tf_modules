variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "builtin_redirectors" {
  type = list(string)
  default = []
}

variable "redirectors" {
  type = object({})
  default = {}
}