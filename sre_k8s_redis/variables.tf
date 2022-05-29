variable "name" {}

variable "domain" {
  default = "redis.local"
}

variable "namespace" {
  type = string
  default = "redis"
}

variable "helm_chart" {
  type = string
  default = "redis"
}

variable "helm_chart_version" {
  type = string
  default = null
}

variable "helm_chart_repository" {
  type = string
  default = "https://charts.bitnami.com/bitnami"
}

variable "helm_chart_values" {
  type = list(string)
  default = []
}