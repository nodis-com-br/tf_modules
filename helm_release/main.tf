resource "helm_release" "this" {
  provider = helm
  name = var.name
  namespace = var.namespace
  repository = var.repository
  chart = var.chart
  values = var.values
  max_history = var.max_history
  create_namespace = var.create_namespace
  cleanup_on_fail = var.cleanup_on_fail
  timeout = var.timeout
  //  atomic                     = false
//  dependency_update          = false
//  disable_crd_hooks          = false
//  disable_openapi_validation = false
//  disable_webhooks           = false
//  force_update               = false
//  lint                       = false
//  recreate_pods              = false
//  render_subchart_notes      = true
//  replace                    = false
//  reset_values               = false
//  reuse_values               = false
//  skip_crds                  = false

//  verify                     = false
//  wait                       = true
//  wait_for_jobs              = false
}
