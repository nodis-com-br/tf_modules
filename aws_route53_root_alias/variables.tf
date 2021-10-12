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

variable "subnet_ids" {
  type = list(string)
}