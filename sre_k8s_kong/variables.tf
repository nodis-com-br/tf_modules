variable "instances" {
  default = ["public", "private"]
}

variable "namespace" {
  type = string
  default = "kong"
}

variable "kong_chart" {
  type = string
  default = "kong"
}

variable "kong_chart_version" {
  type = string
  default = "2.8.0"
}

variable "kong_chart_repository" {
  type = string
  default = "https://charts.konghq.com"
}

variable "kongingress_chart" {
  type = string
  default = "kongingress"
}

variable "kongingress_chart_version" {
  type = string
  default = "2.0.2"
}

variable "kongingress_chart_repository" {
  type = string
  default = "https://charts.nodis.com.br/"
}

variable "public_chart_values" {
  type = list(string)
  default = []
}

variable "private_chart_values" {
  type = list(string)
  default = []
}

variable "default_override_public_namespaces" {
  type = list(string)
  default = ["default"]
}

variable "default_override_private_namespaces" {
  type = list(string)
  default = ["default"]
}