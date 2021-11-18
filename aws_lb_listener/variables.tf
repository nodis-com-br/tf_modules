variable "load_balancer" {
  type = object({
    arn = string
  })
}

variable "port" {
  type = number
  default = "443"
}

variable "protocol" {
  type = string
  protocol = "HTTPS"
}

variable "certificate" {
  type = object({
    arn = string
  })
  default = {
    arn = null
  }
}

variable "actions" {}

variable "rules" {
  default = {}
}