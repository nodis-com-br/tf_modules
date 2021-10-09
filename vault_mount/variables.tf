variable "path" {
  default = "secret"
}

variable "type" {
  default = "kv-v2"
}

variable "default_lease_ttl_seconds" {
  default = 3600
}

variable "max_lease_ttl_seconds" {
  default = 0
}

variable "description" {
  default = "null"
}

variable "options" {
  default = {}
}