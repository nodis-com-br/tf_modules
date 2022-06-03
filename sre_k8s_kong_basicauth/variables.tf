variable "name" {
  default = "basicauth"
}

variable "namespace" {
  type = string
  default = "default"
}

variable "plugin_chart" {
  type = string
  default = "kongplugin"
}

variable "plugin_chart_version" {
  type = string
  default = "2.0.4"
}

variable "consumer_chart" {
  type = string
  default = "kongconsumer"
}

variable "consumer_chart_version" {
  type = string
  default = "2.0.4"
}

variable "charts_repository" {
  type = string
  default = "https://charts.nodis.com.br"
}

variable "ingress_class" {
  default = "kong"
}

variable "consumers" {
  type = list(object({
    username = string
    password = string
  }))
  default = []
}