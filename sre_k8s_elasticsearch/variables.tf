variable "name" {}

variable "environment" {}

variable "schema" {
  default = "https"
}

variable "port" {
  default = "9200"
}

variable "namespace" {
  type = string
  default = "elasticsearch"
}

variable "helm_chart" {
  type = string
  default = "elasticsearch"
}

variable "helm_chart_version" {
  type = string
  default = "2.0.2"
}

variable "helm_chart_repository" {
  type = string
  default = "https://charts.nodis.com.br"
}

variable "helm_chart_values" {
  type = list(string)
  default = []
}

variable "vault_bot_chart" {
  type = string
  default = "vault-bot"
}

variable "vault_bot_chart_version" {
  type = string
  default = "1.0.13"
}

variable "aws_bot_chart_values" {
  type = list(string)
  default = []
}