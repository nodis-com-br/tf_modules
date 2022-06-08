variable "name" {
  type = string
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

variable "subnet_ids" {
  type = list(string)
}

variable "instances" {
  type = list(object({
    id = string
  }))
}

variable "instance_subnet_blocks" {
  type = list(string)
}

variable "log_bucket_name" {}

variable "region" {
  default = "us-east-1"
}

variable "account_id" {}