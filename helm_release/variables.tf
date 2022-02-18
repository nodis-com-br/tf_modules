variable "name" {}

variable "namespace" {
  default = "default"
}

variable "repository" {
  default = null
}

variable "chart" {}

variable "values" {
  default = ["{}"]
}

variable "max_history" {
  default = 1
}

variable "create_namespace" {
  default = true
}

variable "cleanup_on_fail" {
  default = true
}

variable "timeout" {
  default = null
}

variable "wait" {
  default = false
}

variable "chart_version" {
  default = null
}