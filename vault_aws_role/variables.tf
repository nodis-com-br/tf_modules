variable "name" {}

variable "backend" {
  default = null
}

variable "credential_type" {
  default = null
}

variable "policy_arns" {
  default = []
}

variable "role_arns" {
  default = []
}

variable "default_sts_ttl" {
  default = null
}

variable "max_sts_ttl" {
  default = null
}

variable "policy_document" {
  default = null
}