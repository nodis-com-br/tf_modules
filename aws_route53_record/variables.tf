variable "name" {
  type = string
}

variable "type" {
  type = string
  default = "A"
}

variable "records" {
  type = list(string)
  default = []
}


variable "ttl" {
  type = number
  default = 300
}

variable "route53_zone" {
  type = object({
    name = string
    id = string
  })
}

variable "create_certificate" {
  type = bool
  default = false
}

variable "alias" {
  default = null
}
