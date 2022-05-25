variable "name" {}

variable "domain" {}

variable "management_schema" {
  default = "https"
}

variable "management_port" {
  default = "15671"
}

variable "namespace" {
  type = string
  default = "rabbitmq"
}

variable "helm_chart" {
  type = string
  default = "rabbitmq-cluster"
}

variable "helm_chart_version" {
  type = string
  default = "2.0.8"
}

variable "helm_chart_repository" {
  type = string
  default = "https://charts.nodis.com.br/"
}

variable "helm_chart_values" {
  type = list(string)
  default = []
}

variable "vault_role" {
  default = null
}

variable "vault_secret_username" {
  default = "admin"
}

variable "vault_secret_path" {
  default = null
}

variable "vault_kv_backend" {
  default = {path = "secret/"}
}

variable "kubernetes_auth_backend" {
  default = null
}

variable "vault_policy_definitions" {
  type = list(string)
  default = []
}

variable "vault_values" {
  default = null
}