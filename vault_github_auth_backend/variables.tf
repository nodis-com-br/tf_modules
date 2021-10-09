variable "organization" {}

variable "path" {
  default = null
}

variable "default_lease_ttl" {
  default = "6h"
}

variable "max_lease_ttl" {
  default = "2160h"
}
