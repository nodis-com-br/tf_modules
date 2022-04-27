variable "environment" {}

variable "name" {
  default = "amqp0001"
}

variable "namespace" {
  type = string
  default = "rabbitmq"
}

variable "subdomain" {}

variable "helm_chart" {
  type = string
  default = "rabbitmq-cluster"
}

variable "helm_chart_version" {
  type = string
  default = "2.0.8"
}

variable "tls_values" {
  default = null
}

variable "tls_service_annotation_values" {
  default = null
}

variable "management_schema" {
  default = "http"
}

variable "management_port" {
  default = "15672"
}

variable "helm_chart_repository" {
  type = string
  default = "https://charts.nodis.com.br/"
}

variable "helm_chart_values" {
  type = list(string)
  default = []
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