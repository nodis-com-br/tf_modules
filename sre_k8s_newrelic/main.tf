module "newrelic" {
  source = "../helm_release"
  name = "newrelic-bundle"
  namespace = var.namespace
  chart = var.chart_name
  chart_version = var.chart_version
  repository = var.helm_charts_repository
  values = concat(var.values, [
    jsonencode({
      global = {
        licenseKey = var.license_key
        cluster = var.cluster_name
        lowDataMode = true
      }
      ksm = {enabled = true}
      kubeEvents = {enabled = true}
      logging = {enabled = true, fluentBit = {criEnabled = true} }
      prometheus = {enabled = false}
      newrelic-infrastructure = {
        privileged = true
        enableProcessMetrics = false
        config = {
          metrics_network_sample_rate = 60
          metrics_process_sample_rate = 60
          metrics_storage_sample_rate = 60
          metrics_system_sample_rate = 60
          metrics_nfs_sample_rate = 60
        }
      }
      newrelic-logging = {
        nodeAffinity = {
          requiredDuringSchedulingIgnoredDuringExecution = {
            nodeSelectorTerms = [{
              matchExpressions = [{
                key: "nodePoolClass"
                operator: "NotIn"
                values: ["rabbitmq", "elasticsearch"]}]
            }]
          }
        }
      }
    })
  ])
  create_namespace = true
  providers = {
    helm = helm
  }
}
