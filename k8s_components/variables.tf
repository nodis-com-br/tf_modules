variable "environment" {}

variable "cluster_name" {}

variable "cluster_credentials" {
  type = object({
    host = string
    username = string
    password = string
    client_certificate = string
    client_key = string
    cluster_ca_certificate = string
  })
}

variable "http_manifests" {
  type = list(string)
  default = []
}

variable "file_manifests" {
  type = list(string)
  default = []
}

variable "vault_secrets_backend_type" {
  default = "kubernetes"
}

variable "vault_secrets_backend_path" {
  default = "kubernetes/"
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

variable "vault_token_reviewer_sa" {
  default = {
    name = "vault-injector"
    namespace = "vault-injector"
  }
}


#######################################

variable "ghcr_credentials_namespaces" {
  type = list(string)
  default = ["default"]
}

variable "ghcr_credentials_chart" {
  type = string
  default = "nodis/secret"
}

variable "ghcr_credentials_chart_version" {
  type = string
  default = "2.0.0"
}


variable "ghcr_credentials_values" {
  type = list(string)
  default = []
}

#######################################

variable "kongingress_chart" {
  type = string
  default = "nodis/kongingress"
}

variable "kongingress_chart_version" {
  type = string
  default = "2.0.1"
}

variable "kongingress_default_override_namespaces" {
  type = list(string)
  default = ["default"]
}

variable "kongingress_default_override_values" {
  type = list(string)
  default = []
}


#######################################

variable "kongplugin_chart" {
  type = string
  default = "nodis/kongplugin"
}

variable "kongplugin_chart_version" {
  type = string
  default = "2.0.1"
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


#######################################

variable "rabbitmq_name" {
  default = "amqp0001"
}

variable "rabbitmq_chart" {
  type = string
  default = "nodis/rabbitmq-cluster"
}

variable "rabbitmq_chart_version" {
  type = string
  default = "2.0.8"
}

variable "rabbitmq_namespace" {
  type = string
  default = "rabbitmq"
}

variable "rabbitmq_chart_values" {
  type = list(string)
  default = []
}

variable "rabbitmq_vault_secret_path" {
  default = null
}

variable "rabbitmq_vault_policy_definitions" {
  type = list(string)
  default = []
}