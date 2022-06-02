variable "name" {}

variable "namespace" {
  type = string
  default = "botland"
}

variable "vault_role_name" {
  default = null
}

variable "service_account_name" {
  default = null
}

variable "vault_auth_backend" {}

variable "vault_policies" {
  type = list(string)
}

variable "chart_name" {
  type = string
  default = "vault-bot"
}

variable "chart_version" {
  type = string
  default = "1.1.2"
}

variable "helm_chart_repository" {
  type = string
  default = "https://charts.nodis.com.br"
}

variable "chart_values" {
  type = list(string)
}