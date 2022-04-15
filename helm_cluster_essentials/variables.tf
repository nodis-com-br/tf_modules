variable "ghcr_credentials" {
  type = bool
  default = true
}

variable "ghcr_credentials_chart" {
  type = string
  default = "nodis/secret"
}

variable "ghcr_credentials_chart_version" {
  type = string
  default = "2.0.0"
}

variable "ghcr_credentials_namespaces" {
  type = list(string)
  default = ["default"]
}

variable "ghcr_credentials_values" {
  type = list(string)
  default = []
}

variable "kong_default_override" {
  type = bool
  default = true
}

variable "kong_default_override_chart" {
  type = string
  default = "nodis/kongingress"
}

variable "kong_default_override_chart_version" {
  type = string
  default = "2.0.1"
}

variable "kong_default_override_namespaces" {
  type = list(string)
  default = ["default"]
}

variable "kong_default_override_values" {
  type = list(string)
  default = []
}

variable "endpoint_bots" {
  type = bool
  default = true
}

variable "endpoint_bots_chart" {
  type = string
  default = "nodis/endpoint-bots"
}

variable "endpoint_bots_chart_version" {
  type = string
  default = "2.0.21"
}

variable "endpoint_bots_namespace" {
  type = string
  default = "botland"
}

variable "endpoint_bots_values" {
  type = list(string)
  default = []
}

variable "newrelic" {
  type = bool
  default = true
}

variable "newrelic_chart" {
  type = string
  default = "nri-bundle"
}

variable "newrelic_chart_version" {
  type = string
  default = "3.4.0"
}

variable "newrelic_repository" {
  type = string
  default = "https://helm-charts.newrelic.com"
}

variable "newrelic_namespace" {
  type = string
  default = "newrelic"
}

variable "newrelic_values" {
  type = list(string)
  default = []
}


variable "vault_injector" {
  type = bool
  default = true
}

variable "vault_injector_chart" {
  type = string
  default = "vault"
}

variable "vault_injector_chart_version" {
  type = string
  default = null
}

variable "vault_injector_repository" {
  type = string
  default = "https://helm.releases.hashicorp.com/"
}

variable "vault_injector_namespace" {
  type = string
  default = "vault-injector"
}

variable "vault_injector_values" {
  type = list(string)
  default = []
}