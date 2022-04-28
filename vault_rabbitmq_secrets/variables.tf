variable "connection_uri" {}

variable "username" {
  type = string
  default = "vault-secret-backend"
}

variable "path" {}

variable "user_tags" {
  type = list(string)
  default = ["administrator"]
}

variable "default_lease_ttl_seconds" {
  default = null
}
variable "max_lease_ttl_seconds" {
  default = null
}