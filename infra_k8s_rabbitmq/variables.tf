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

variable "tls_service_annotations_values" {
  default = null
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

variable "kubernetes_auth_backend" {
  default = null
}

variable "vault_policy_definitions" {
  type = list(string)
  default = []
}