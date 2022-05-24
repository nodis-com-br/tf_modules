module "elasticsearch" {
  source = "../helm_release"
  name = var.name
  chart = var.helm_chart
  chart_version = var.helm_chart_version
  repository = var.helm_chart_repository
  namespace = var.namespace
  create_namespace = true
  values = var.helm_chart_values
  providers = {
    helm = helm
  }
}



module "vault_secrets_backend" {
  source = "../vault_mount"
  path = "elasticsearch/${var.environment}-${var.name}"
  type = "database"
}


