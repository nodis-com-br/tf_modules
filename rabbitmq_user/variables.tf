variable "username" {}

variable "password" {
  default = null
}

variable "user_tags" {
  type = list(string)
  default = []
}

variable "password_length" {
  default = 16
}

variable "password_special" {
  default = false
}

variable "permissions" {
  type = map(object({
    configure = string
    write = string
    read = string
  }))
  default = {
    "/" = {
      configure = ".*"
      write = ".*"
      read = ".*"
    }
  }
}