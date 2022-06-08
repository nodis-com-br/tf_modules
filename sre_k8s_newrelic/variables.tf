variable "license_key" {}

variable "cluster_name" {}

variable "chart_name" {
  type = string
  default = "nri-bundle"
}

variable "chart_version" {
  type = string
  default = "3.4.0"
}

variable "helm_charts_repository" {
  type = string
  default = "https://helm-charts.newrelic.com"
}

variable "namespace" {
  type = string
  default = "newrelic"
}

variable "values" {
  type = list(string)
  default = []
}

variable "rabbitmq_instances" {
  default = []
}