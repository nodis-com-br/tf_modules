variable "name" {}

variable "registry" {
  default = "ghcr.io"
}

variable "github_token" {}

variable "environment" {
  default = "prod"
}

variable "namespace" {
  type = string
  default = "default"
}

variable "helm_chart" {
  type = string
  default = "deployment"
}

variable "helm_chart_version" {
  type = string
  default = "2.0.5"
}

variable "helm_chart_repository" {
  type = string
  default = "https://charts.nodis.com.br"
}

variable "helm_chart_values" {
  type = list(string)
  default = []
}

variable "kubeconfig" {}