variable "organization" {}

variable "path" {
  default = null
}

variable "default_lease_ttl" {
  default = "720h"
}

variable "max_lease_ttl" {
  default = "720h"
}
