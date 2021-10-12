variable "route53_zone" {
  type = object({
    name = string
    id = string
  })
}

variable "alias" {
  type = string
}

variable "vpc" {
  type = object({
    id = string
  })
}

variable "subnets" {
  type = list(object({
    id = string
  }))
}