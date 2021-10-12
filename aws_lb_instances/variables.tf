variable "name" {
  type = string
}

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

variable "instances" {
  type = map(object({
    id = string
  }))
}

variable "instance_subnet_ids" {
  type = list(object({
    id = string
  }))
}