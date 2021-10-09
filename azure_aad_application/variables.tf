variable "name" {}

variable "group_ids" {
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

variable "resource_access" {}

variable "secret_path" {
  default = null
}

variable "subscription_id" {
  default = null
}

variable "tenant_id" {
  default = null
}