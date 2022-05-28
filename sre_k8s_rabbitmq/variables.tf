variable "name" {}

variable "domain" {
  default = "rabbitmq.local"
}

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

variable "enable_vault" {
  default = false
}

variable "vault_role" {
  default = null
}

variable "vault_pki_issuer_path" {
  default = "pki/rabbitmq/issue/server"
}

variable "vault_secret_path" {
  default = null
}

variable "vault_kv_backend" {
  default = "secret/"
}

variable "kubernetes_auth_backend" {
  default = null
}
