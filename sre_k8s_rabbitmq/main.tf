resource "random_string" "this" {
  count = var.enable_vault ? 1 : 0
  length = 16
  special = false
}

resource "random_password" "this" {
  count = var.enable_vault ? 1 : 0
  length  = 16
  special = false
}

module "vault_kv_secret" {
  source = "../vault_secret"
  count = var.enable_vault ? 1 : 0
  path = var.vault_secret_path
  data_json = jsonencode({
    username = random_string.this[0].result
    password = random_password.this[0].result
  })
}

module "rabbitmq_k8s_auth_role" {
  source = "../vault_k8s_auth_role"
  count = var.enable_vault ? 1 : 0
  backend = try(var.kubernetes_auth_backend.path, var.kubernetes_auth_backend)
  name = var.vault_role
  bound_service_account_names = ["${var.name}-server"]
  bound_service_account_namespaces = [var.namespace]
  policy_definitions = [
    "path \"${module.vault_kv_secret[0].data_path}\" {capabilities = [\"read\"]}",
    "path \"${var.vault_pki_issuer_path}\" {capabilities = [\"create\"]}"
  ]
}

module "rabbitmq" {
  source = "../helm_release"
  name = var.name
  namespace = var.namespace
  chart = var.helm_chart
  chart_version = var.helm_chart_version
  repository = var.helm_chart_repository
  create_namespace = true
  values = concat(var.helm_chart_values, [
    jsonencode({service = {annotations = {"nodis.com.br/managed-domain" = var.domain}}}),
    jsonencode({override = {service = {spec = {ports = [
      {name = "amqp", protocol = "TCP", appProtocol = "tcp", port = 5672, targetPort = 5672},
      {name = "amqps", protocol = "TCP", appProtocol = "tcp", port = 5671, targetPort = 5671},
      {name = "prometheus", protocol = "TCP", appProtocol = "http", port = 15692, targetPort = 15692},
      {name = "prometheus-tls", protocol = "TCP", appProtocol = "https", port = 15691, targetPort = 15691},
      {name = "management", protocol = "TCP", appProtocol = "tcp", port = 15672, targetPort = 15672},
      {name = "management-tls", protocol = "TCP", appProtocol = "tcp", port = 15671, targetPort = 15671}
    ]}}}}),
    var.enable_vault ? jsonencode({
      secretBackend = {vault = {
        annotations = {"vault.hashicorp.com/agent-service-account-token-volume-name" = "token"}
        defaultUserPath = module.vault_kv_secret[0].data_path
        role = var.vault_role
        tls = {altNames = var.domain, pkiIssuerPath = var.vault_pki_issuer_path}
      }}
      override = {statefulSet = {spec = {template = {spec = {
        containers = []
        volumes = [{
          name = "token"
          projected = {sources = [{serviceAccountToken = {path = "token", expirationSeconds = 3600, audience = "vault"}}]}
        }]
      }}}}}
    }) : "{}"
  ])
  providers = {
    helm = helm
  }
}
