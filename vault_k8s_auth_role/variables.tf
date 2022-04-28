variable "backend" {}

variable "name" {}

variable "audience" {
  default = "vault"
}

variable "token_ttl" {
  default = null
}

variable "token_max_ttl" {
  default = null
}

variable "bound_service_account_names" {
  default = []
}

variable "bound_service_account_namespaces" {
  default = []
}

variable "policies" {
  default = []
}

variable "policy_definitions" {
  default = {}
}