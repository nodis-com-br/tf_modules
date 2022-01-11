variable "name" {}

variable "namespace" {
  default = "default"
}

variable "repository" {}

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
  default = 120
}