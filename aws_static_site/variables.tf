variable name {}

variable "bucket" {}

variable "domain" {}

variable "alternative_domain_names" {
  type = list(string)
  default = []
}

variable "role_owner_arn" {}

variable "route53_zone" {}

variable "default_root_object" {
  default = "index.html"
}

variable "origin_path" {
  default = "/www"
}

variable "cloudfront_enabled" {
  default = true
}