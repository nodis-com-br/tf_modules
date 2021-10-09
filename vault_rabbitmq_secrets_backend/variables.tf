variable "connection_uri" {}

variable "username" {}

variable "password" {}

variable "default_lease_ttl_seconds" {
  default = 3600
}

variable "max_lease_ttl_seconds" {
  default = 604800
}