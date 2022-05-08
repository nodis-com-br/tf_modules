variable "cluster_host" {}

variable "cluster_ca_certificate" {}

variable "http_manifests" {
  type = list(string)
  default = []
}

variable "file_manifests" {
  type = list(string)
  default = []
}


#######################################

variable "vault_backend_path" {}

variable "vault_secrets_service_account_name" {
  default = "vault-secrets-backend"
}

variable "vault_secrets_service_account_ruleset" {
  type = list(object({
    api_groups = list(string)
    resources = list(string)
    verbs = list(string)
  }))
  default = []
}

variable "vault_secrets_backend_type" {
  default = "kubernetes"
}

variable "vault_chart" {
  type = string
  default = "vault"
}

variable "vault_chart_version" {
  type = string
  default = null
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

variable "vault_token_reviewer_sa" {
  default = "vault-injector"
}

#######################################

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

variable "endpoint_bots_chart" {
  type = string
  default = "endpoint-bots"
}

variable "endpoint_bots_chart_version" {
  type = string
  default = "2.0.22"
}
#######################################

variable "secret_ghcr_credentials_chart_namespaces" {
  type = list(string)
  default = []
}

variable "secret_ghcr_credentials_chart_values" {
  type = list(string)
  default = []
}

#######################################

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

#######################################

variable "endpoint_bots_name" {
  default = "endpoint-bots"
}

variable "endpoint_bots_namespace" {
  type = string
  default = "botland"
}

variable "endpoint_bots_values" {
  type = list(string)
  default = []
}

variable "endpoint_bots_vault_policy_definitions" {
  type = list(string)
  default = []
}

#######################################

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


#######################################

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


#######################################

variable "redis_chart" {
  type = string
  default = "redis"
}

variable "redis_chart_version" {
  type = string
  default = null
}

variable "redis_chart_repository" {
  type = string
  default = "https://charts.bitnami.com/bitnami"
}

variable "redis_namespace" {
  type = string
  default = "redis"
}

variable "redis_chart_values" {
  type = list(string)
  default = []
}