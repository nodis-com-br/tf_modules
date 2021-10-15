variable "name" {}

variable "rg" {
  type = object({
    location = string
    name = string
  })
}

variable "schedules" {
  default = {}
}

variable "builtin_schedules" {
  type = list(string)
  default = []
}

variable "runbooks" {
  default = {}
}

variable "builtin_runbooks" {
  type = list(string)
  default = []
}