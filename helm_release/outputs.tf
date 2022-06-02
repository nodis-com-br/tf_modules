output "this" {
  value = helm_release.this
}

output "values" {
  value = jsondecode(helm_release.this.metadata[0].values)
}