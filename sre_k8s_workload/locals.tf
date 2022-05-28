locals {
  repository = jsondecode(module.workload.this.metadata[0].values)["image"]["repository"]
}