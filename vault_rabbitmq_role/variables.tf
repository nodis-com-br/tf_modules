variable "name" {}

variable "backend" {
  default = null
}

variable "tags" {
  default = ""
  type = string
}

variable "vhosts" {
  type = list(object({
    host = string
    configure = string
    read = string
    write = string
  }))
}