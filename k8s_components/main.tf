module "http_manifests" {
  source = "../kubectl_manifests"
  count = length(var.http_manifests) > 0 ? 1 : 0
  type = "http"
  sources = var.http_manifests
  providers = {
    kubectl = kubectl
  }
}

module "file_manifests" {
  source = "../kubectl_manifests"
  count = length(var.file_manifests) > 0 ? 1 : 0
  type = "file"
  sources = var.file_manifests
  providers = {
    kubectl = kubectl
  }
}

module "vault_secrets_backend" {
  source = "../vault_k8s_secrets"
  type = var.vault_secrets_backend_type
  path = "${var.vault_secrets_backend_path}${var.cluster_name}"
  host = var.cluster_credentials.host
  ca_cert = var.cluster_credentials.cluster_ca_certificate
  jwt = var.cluster_credentials.password
}

module "vault_injector" {
  source = "../helm_release"
  count = length(var.vault_injector_values) > 0 ? 1 : 0
  name = "vault-injector"
  namespace = var.vault_injector_namespace
  chart = var.vault_injector_chart
  chart_version = var.vault_injector_chart_version
  repository = var.vault_injector_repository
  values = var.vault_injector_values
  providers = {
    helm = helm
  }
}

module "vault_auth_backend" {
  source = "../vault_k8s_auth"
  count = length(var.vault_injector_values) > 0 ? 1 : 0
  path = var.cluster_name
  host = var.cluster_credentials.host
  ca_certificate = var.cluster_credentials.cluster_ca_certificate
  token = data.kubernetes_secret.vault-injector-token.0.data.token
  depends_on = [
    module.vault_injector
  ]
}

module "ghcr_credentials" {
  source = "../helm_release"
  for_each = toset(var.ghcr_credentials_namespaces)
  name = "ghcr-credentials"
  namespace = each.key
  chart = var.ghcr_credentials_chart
  chart_version = var.ghcr_credentials_chart_version
  values = var.ghcr_credentials_values
  providers = {
    helm = helm
  }
}

module "kongingress_default_override" {
  source = "../helm_release"
  for_each = toset(var.kongingress_default_override_namespaces)
  name = "default-override"
  namespace = each.key
  chart = var.kongingress_chart
  chart_version = var.kongingress_chart_version
  values = var.kongingress_default_override_values
  providers = {
    helm = helm
  }
}

module "kongplugin_prometheus" {
  source = "../helm_release"
  for_each = toset(length(var.kongplugin_prometheus_chart_values) > 0 ? var.kong_ingress_classes : [])
  name = "prometheus-${each.key}"
  chart = var.kongplugin_chart
  chart_version = var.kongplugin_chart_version
  values = concat(var.kongplugin_prometheus_chart_values, [
    jsonencode({
      annotations = {"kubernetes.io/ingress.class" = "kong-${each.key}"}
    })
  ])
  providers = {
    helm = helm
  }
}

module "kongplugin_gh_auth" {
  source = "../helm_release"
  for_each = toset(length(var.kongplugin_gh_auth_chart_values) > 0 ? var.kong_ingress_classes : [])
  name = "gh_auth-${each.key}"
  chart = var.kongplugin_chart
  chart_version = var.kongplugin_chart_version
  values = concat(var.kongplugin_gh_auth_chart_values, [
    jsonencode({
      annotations = {"kubernetes.io/ingress.class" = "kong-${each.key}"}
    })
  ])
  providers = {
    helm = helm
  }
}

module "endpoint_bots" {
  source = "../helm_release"
  count = length(var.endpoint_bots_values) > 0 ? 1 : 0
  name = var.endpoint_bots_name
  namespace = var.endpoint_bots_namespace
  chart = var.endpoint_bots_chart
  chart_version = var.endpoint_bots_chart_version
  values = var.endpoint_bots_values
  providers = {
    helm = helm
  }
}

module "endpoint_bots_k8s_auth_role" {
  source = "../vault_k8s_auth_role"
  count = length(var.endpoint_bots_vault_policy_definitions) > 0 ? 1 : 0
  backend = module.vault_auth_backend[0].this.path
  name = "${var.environment}-${var.endpoint_bots_name}"
  bound_service_account_names = [var.endpoint_bots_name]
  bound_service_account_namespaces = [var.endpoint_bots_namespace]
  policy_definitions = var.endpoint_bots_vault_policy_definitions
}


module "newrelic" {
  source = "../helm_release"
  count = length(var.newrelic_values) > 0 ? 1 : 0
  name = "newrelic-bundle"
  namespace = var.newrelic_namespace
  chart = var.newrelic_chart
  chart_version = var.newrelic_chart_version
  repository = var.newrelic_repository
  values = var.newrelic_values
  providers = {
    helm = helm
  }
}

module "kong_public" {
  source = "../helm_release"
  count = length(var.kong_public_chart_values) > 0 ? 1 : 0
  name = "kong-public"
  namespace = var.kong_namespace
  chart = var.kong_chart
  chart_version = var.kong_chart_version
  repository = var.kong_chart_repository
  values = var.kong_public_chart_values
  providers = {
    helm = helm
  }
}

module "kong_private" {
  source = "../helm_release"
  count = length(var.kong_private_chart_values) > 0 ? 1 : 0
  name = "kong-private"
  namespace = var.kong_namespace
  chart = var.kong_chart
  chart_version = var.kong_chart_version
  repository = var.kong_chart_repository
  values = var.kong_private_chart_values
  providers = {
    helm = helm
  }
}

module "redis" {
  source = "../helm_release"
  count = length(var.redis_chart_values) > 0 ? 1 : 0
  name = "redis"
  namespace = var.redis_namespace
  chart = var.redis_chart
  chart_version = var.redis_chart_version
  repository = var.redis_chart_repository
  values = var.redis_chart_values
  providers = {
    helm = helm
  }
}

#######################################

resource "random_password" "rabbitmq" {
  count = var.rabbitmq_vault_secret_path == null ? 0 : 1
  length  = 16
  special = false
}

module "rabbitmq_kv_secret" {
  source = "../vault_secret"
  count = var.rabbitmq_vault_secret_path == null ? 0 : 1
  path = var.rabbitmq_vault_secret_path
  data_json = jsonencode({
    username = "admin"
    password = random_password.rabbitmq[0].result
  })
}

module "rabbitmq_k8s_auth_role" {
  source = "../vault_k8s_auth_role"
  count = length(var.rabbitmq_vault_policy_definitions) > 0 ? 1 : 0
  backend = module.vault_auth_backend[0].this.path
  name = "${var.environment}_${var.rabbitmq_name}"
  bound_service_account_names = ["${var.rabbitmq_name}-server"]
  bound_service_account_namespaces = [var.rabbitmq_namespace]
  policy_definitions = var.rabbitmq_vault_policy_definitions
}

module "rabbitmq" {
  source = "../helm_release"
  count = length(var.rabbitmq_chart_values) > 0 ? 1 : 0
  name = var.rabbitmq_name
  namespace = var.rabbitmq_namespace
  chart = var.rabbitmq_chart
  chart_version = var.rabbitmq_chart_version
  values = var.rabbitmq_chart_values
  providers = {
    helm = helm
  }
}

resource "vault_rabbitmq_secret_backend" "this" {
  count = length(var.rabbitmq_chart_values) > 0 ? data.kubernetes_secret.rabbitmq_default_user[0].data != null && data.kubernetes_service.rabbitmq[0].metadata != null ? 1 : 0 : 0
  path = "rabbitmq/${var.environment}-${var.rabbitmq_name}"
  connection_uri = "https://${data.kubernetes_service.rabbitmq[0].metadata[0].annotations["nodis.com.br/managed-domain"]}:15671"
  username = data.kubernetes_secret.rabbitmq_default_user[0].data.username
  password = data.kubernetes_secret.rabbitmq_default_user[0].data.password
}