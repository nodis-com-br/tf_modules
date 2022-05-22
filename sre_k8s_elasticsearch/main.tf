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

module "aws_bot" {
  source = "../helm_release"
  count = length(var.aws_bot_chart_values) > 0 ? 1 : 0
  name = "${var.name}-aws-bot"
  namespace = var.namespace
  chart = var.vault_bot_chart
  chart_version = var.vault_bot_chart_version
  repository = var.helm_chart_repository
  values = var.aws_bot_chart_values
  providers = {
    helm = helm
  }
}

module "vault_secrets_backend" {
  source = "../vault_mount"
  path = "elasticsearch/${var.name}"
  type = "database"
}


