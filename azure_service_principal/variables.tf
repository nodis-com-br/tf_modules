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