# Cluster #####################################################################

variable "cluster" {
  type = object({
    this = object({name = string})
    credentials = object({
      host = string
      cluster_ca_certificate = string
    })
  })
}

# Vault #######################################################################

variable "vault_chart" {
  type = string
  default = "vault"
}

variable "vault_chart_version" {
  type = string
  default = "0.20.1"
}

variable "vault_chart_repository" {
  type = string
  default = "https://helm.releases.hashicorp.com/"
}

variable "vault_injector_chart_namespace" {
  type = string
  default = "vault-injector"
}

variable "vault_injector_chart_values" {
  type = list(string)
  default = []
}


# Custom charts ###############################################################

variable "helm_chart_repository" {
  type = string
  default = "https://charts.nodis.com.br/"
}

variable "vault_bot_chart" {
  type = string
  default = "vault-bot"
}

variable "vault_bot_chart_version" {
  type = string
  default = "1.1.1"
}

# botland #####################################################################

variable "bots_namespace" {
  type = string
  default = "botland"
}

# endpoint_bots #######################

variable "endpoint_bots_name" {
  default = "endpoint-bots"
}

variable "endpoint_bots_chart" {
  type = string
  default = "endpoint-bots"
}

variable "endpoint_bots_chart_version" {
  type = string
  default = "2.0.23"
}

variable "endpoint_bots_chart_values" {
  type = list(string)
  default = []
}

variable "endpoint_bots_vault_policy_definitions" {
  type = list(string)
  default = []
}

# ghcr_credentials_bot ################

variable "ghcr_credentials_bot_name" {
  default = "ghcr-credentials-bot"
}

variable "ghcr_credentials_bot_chart_values" {
  type = list(string)
  default = []
}

variable "ghcr_credentials_bot_vault_policy_definitions" {
  type = list(string)
  default = []
}

# New Relic ###################################################################

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