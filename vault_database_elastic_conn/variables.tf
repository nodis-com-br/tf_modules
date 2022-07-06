variable "name" {}

variable "backend" {}

variable "elasticsearch_url" {}

variable "allowed_roles" {
  type = list(string)
  default = null
}

variable "role_name_prefix" {
  default = "vault"
}

variable "vault_token" {}