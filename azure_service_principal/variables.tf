variable "name" {}

variable "group_ids" {
  default = []
}

variable "builtin_roles" {
  default = []
}

variable "roles" {
  default = {}
  type = map(object({
    scope = string
    definition_name = string
  }))
}

variable "create_password" {
  default = false
}

variable "builtin_resource_accesses" {
  default = []
}

variable "resource_accesses" {
  default = {}
}

variable "homepage_url" {
  default = null
}

variable "save_credentials" {
  default = false
}

variable "vault_secrets_backend" {
  default = "azure/"
}

variable "vault_kv_backend" {
  default = "secret/"
}

variable "vault_role" {
  default = null
}

variable "vault_ttl" {
  default = null
}

variable "vault_max_ttl" {
  default = null
}