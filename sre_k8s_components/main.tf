# Vault #######################################################################

module "vault_injector" {
  source = "../helm_release"
  count = length(var.vault_injector_chart_values) > 0 ? 1 : 0
  name = "vault-injector"
  namespace = var.vault_injector_chart_namespace
  chart = var.vault_chart
  chart_version = var.vault_chart_version
  repository = var.vault_chart_repository
  create_namespace = true
  values = var.vault_injector_chart_values
  providers = {
    helm = helm
  }
}

module "vault_auth_backend" {
  source = "../vault_k8s_auth"
  count = length(var.vault_injector_chart_values) > 0 ? 1 : 0
  path = "${var.vault_backend_type}/${var.cluster.this.name}"
  host = var.cluster.credentials.host
#  ca_certificate = var.cluster.credentials.cluster_ca_certificate
#  token = data.kubernetes_secret.vault-injector-token[0].data.token
  depends_on = [
    module.vault_injector
  ]
}

# botland #####################################################################

module "endpoint_bots_k8s_auth_role" {
  source = "../vault_k8s_auth_role"
  count = length(var.endpoint_bots_vault_policy_definitions) > 0 ? 1 : 0
  backend = module.vault_auth_backend[0].this.path
  name = var.endpoint_bots_name
  bound_service_account_names = [var.endpoint_bots_name]
  bound_service_account_namespaces = [var.bots_namespace]
  policy_definitions = var.endpoint_bots_vault_policy_definitions
}

module "endpoint_bots" {
  source = "../helm_release"
  count = length(var.endpoint_bots_chart_values) > 0 ? 1 : 0
  name = var.endpoint_bots_name
  namespace = var.bots_namespace
  chart = var.endpoint_bots_chart
  chart_version = var.endpoint_bots_chart_version
  repository = var.default_chart_repository
  create_namespace = true
  values = var.endpoint_bots_chart_values
  depends_on = [
    module.endpoint_bots_k8s_auth_role[0]
  ]
  providers = {
    helm = helm
  }
}

module "ghcr_credentials_bot_k8s_auth_role" {
  source = "../vault_k8s_auth_role"
  count = length(var.ghcr_credentials_bot_vault_policy_definitions) > 0 ? 1 : 0
  backend = module.vault_auth_backend[0].this.path
  name = var.ghcr_credentials_bot_name
  bound_service_account_names = [var.ghcr_credentials_bot_name]
  bound_service_account_namespaces = [var.bots_namespace]
  policy_definitions = var.ghcr_credentials_bot_vault_policy_definitions
}

module "ghcr_credentials_bot" {
  source = "../helm_release"
  count = length(var.ghcr_credentials_bot_chart_values) > 0 ? 1 : 0
  name = var.ghcr_credentials_bot_name
  namespace = var.bots_namespace
  chart = var.vault_bot_chart
  chart_version = var.vault_bot_chart_version
  repository = var.default_chart_repository
  create_namespace = true
  values = var.ghcr_credentials_bot_chart_values
  depends_on = [
    module.ghcr_credentials_bot_k8s_auth_role[0]
  ]
  providers = {
    helm = helm
  }
}

# Kong ########################################################################

module "kong_public" {
  source = "../helm_release"
  count = length(var.kong_public_chart_values) > 0 ? 1 : 0
  name = "kong-public"
  namespace = var.kong_namespace
  chart = var.kong_chart
  chart_version = var.kong_chart_version
  repository = var.kong_chart_repository
  values = var.kong_public_chart_values
  create_namespace = true
  skip_crds = true
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
  create_namespace = true
  skip_crds = true
  values = var.kong_private_chart_values
  providers = {
    helm = helm
  }
}

module "kongingress_default_override_public" {
  source = "../helm_release"
  for_each = toset(var.kongingress_default_override_namespaces_public)
  name = "default-override-public"
  namespace = each.key
  chart = var.kongingress_chart
  repository = var.default_chart_repository
  chart_version = var.kongingress_chart_version
  create_namespace = true
  values = concat(var.kongingress_default_override_values, [
    jsonencode({
      annotations = {"kubernetes.io/ingress.class" = "kong-public"}
    })
  ])
  providers = {
    helm = helm
  }
}

module "kongingress_default_override_private" {
  source = "../helm_release"
  for_each = toset(var.kongingress_default_override_namespaces_private)
  name = "default-override-private"
  namespace = each.key
  chart = var.kongingress_chart
  repository = var.default_chart_repository
  chart_version = var.kongingress_chart_version
  create_namespace = true
  values = concat(var.kongingress_default_override_values, [
    jsonencode({
      annotations = {"kubernetes.io/ingress.class" = "kong-private"}
    })
  ])
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
  repository = var.default_chart_repository
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
  repository = var.default_chart_repository
  values = concat(var.kongplugin_gh_auth_chart_values, [
    jsonencode({
      annotations = {"kubernetes.io/ingress.class" = "kong-${each.key}"}
    })
  ])
  providers = {
    helm = helm
  }
}

# Miscellanea #################################################################

module "newrelic" {
  source = "../helm_release"
  count = length(var.newrelic_values) > 0 ? 1 : 0
  name = "newrelic-bundle"
  namespace = var.newrelic_namespace
  chart = var.newrelic_chart
  chart_version = var.newrelic_chart_version
  repository = var.newrelic_repository
  values = var.newrelic_values
  create_namespace = true
  providers = {
    helm = helm
  }
}
