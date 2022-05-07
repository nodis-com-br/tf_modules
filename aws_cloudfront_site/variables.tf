variable name {}

variable "bucket" {}

variable "domain" {}

variable "alternative_domain_names" {
  type = list(string)
  default = []
}

variable "role_owner_arn" {
  default = null
}

variable "vault_role" {
  default = null
}

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

variable "cloudfront_policy" {
  default = false
}

variable "geo_restriction" {
  type = object({
    locations = list(string)
    type = string
  })
  default = {
    locations = []
    type = "none"
  }
}