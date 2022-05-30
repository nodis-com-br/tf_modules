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

variable "vault_backend_type" {
  default = "kubernetes"
}

variable "vault_chart" {
  type = string
  default = "vault"
}

variable "vault_chart_version" {
  type = string
  default = "0.16.1"
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

variable "default_chart_repository" {
  type = string
  default = "https://charts.nodis.com.br/"
}

variable "secret_chart" {
  type = string
  default = "secret"
}

variable "secret_chart_version" {
  type = string
  default = "2.0.0"
}

variable "kongingress_chart" {
  type = string
  default = "kongingress"
}

variable "kongingress_chart_version" {
  type = string
  default = "2.0.2"
}

variable "kongplugin_chart" {
  type = string
  default = "kongplugin"
}

variable "kongplugin_chart_version" {
  type = string
  default = "2.0.1"
}

variable "vault_bot_chart" {
  type = string
  default = "vault-bot"
}

variable "vault_bot_chart_version" {
  type = string
  default = "1.0.11"
}

# Kong ########################################################################

variable "kong_ingress_classes" {
  default = ["public", "private"]
}

variable "kong_chart" {
  type = string
  default = "kong"
}

variable "kong_chart_version" {
  type = string
  default = null
}

variable "kong_chart_repository" {
  type = string
  default = "https://charts.konghq.com"
}

variable "kong_namespace" {
  type = string
  default = "kong"
}

variable "kong_public_chart_values" {
  type = list(string)
  default = []
}

variable "kong_private_chart_values" {
  type = list(string)
  default = []
}

variable "kongingress_default_override_namespaces_public" {
  type = list(string)
  default = []
}

variable "kongingress_default_override_namespaces_private" {
  type = list(string)
  default = []
}

variable "kongingress_default_override_values" {
  type = list(string)
  default = []
}

variable "kongplugin_prometheus_chart_values" {
  type = list(string)
  default = []
}

variable "kongplugin_gh_auth_chart_values" {
  type = list(string)
  default = []
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