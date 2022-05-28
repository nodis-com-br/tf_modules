locals {
  rendered_values = jsondecode(module.workload.this.metadata[0].values)
}