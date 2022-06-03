variable "port" {
  default = 80
}

variable "protocol" {
  default = "HTTP"
}

variable "vpc" {
  type = object({
    id = string
  })
}

variable "target_type" {}

variable "health_check" {
  default = {
    path = "/"
    matcher = "200"
  }
}

variable "targets" {
  default = []
}