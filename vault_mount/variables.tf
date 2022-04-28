variable "path" {
  default = "secret"
}

variable "type" {
  default = "kv-v2"
}

variable "default_lease_ttl_seconds" {
  default = null
}

variable "max_lease_ttl_seconds" {
  default = null
}

variable "description" {
  default = "null"
}

variable "options" {
  default = {}
}