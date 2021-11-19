variable "domain" {
  type = string
}

variable "log_bucket_name" {}

variable "port" {
  default = "443"
}

variable "protocol" {
  default = "HTTPS"
}

variable "route53_zone" {
  type = object({
    name = string
    id = string
  })
}

variable "vpc" {
  type = object({
    id = string
  })
}

variable "subnets" {
  type = list(object({
    id = string
    cidr_block = string
  }))
}

variable "actions" {
  default = {}
}

variable "rules" {
  default = {}
}

variable "dns_type" {
  default = "record"
}