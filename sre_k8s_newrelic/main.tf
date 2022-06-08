module "newrelic" {
  source = "../helm_release"
  name = "newrelic-bundle"
  namespace = var.namespace
  chart = var.chart_name
  chart_version = var.chart_version
  repository = var.helm_charts_repository
  create_namespace = true
  values = concat(var.values, [
    jsonencode({global = {licenseKey = var.license_key}}),
    jsonencode({global = {cluster = var.cluster_name}}),
    jsonencode({global = {lowDataMode = true}}),
    jsonencode({ksm = {enabled = true}}),
    jsonencode({kubeEvents = {enabled = true}}),
    jsonencode({logging = {enabled = true}}),
    jsonencode({logging = {fluentBit = {criEnabled = true}}}),
    jsonencode({prometheus = {enabled = false}}),
    jsonencode({newrelic-infrastructure = {privileged = true}}),
    jsonencode({newrelic-infrastructure = {enableProcessMetrics = false}}),
    jsonencode({newrelic-infrastructure = {config = {metrics_network_sample_rate = 60}}}),
    jsonencode({newrelic-infrastructure = {config = {metrics_process_sample_rate = 60}}}),
    jsonencode({newrelic-infrastructure = {config = {metrics_storage_sample_rate = 60}}}),
    jsonencode({newrelic-infrastructure = {config = {metrics_system_sample_rate = 60}}}),
    jsonencode({newrelic-infrastructure = {config = {metrics_nfs_sample_rate = 60}}}),
    jsonencode({newrelic-logging = {nodeAffinity = {requiredDuringSchedulingIgnoredDuringExecution = {nodeSelectorTerms = [{
      matchExpressions = [{
        key: "nodePoolClass"
        operator: "NotIn"
        values: ["rabbitmq", "elasticsearch"]
      }]
    }]}}}})
  ], [for r in var.rabbitmq_instances : format(local.rabbitmq_integration, r["name"], r["environment"], r["username"], r["password"])])
  providers = {
    helm = helm
  }
}