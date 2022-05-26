variable "name" {
  default = null
}

variable "assume_role_principal" {
  default = null
}

variable "assume_role_policy" {
  default = null
}

variable "policy_statements" {
  default = []
}

variable "policy_arns" {
  type = list(string)
  default = []
}

variable "vault_role" {
  default = null
}

variable "vault_backend" {
  default = null
}

variable "vault_credential_type" {
  default = null
}