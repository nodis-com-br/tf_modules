variable "organization" {}

variable "path" {
  default = null
}

variable "default_lease_ttl" {
  default = "8h"
}

variable "max_lease_ttl" {
  default = "768h"
}
