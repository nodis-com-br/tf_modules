output "this" {
  value = helm_release.this
}

output "template" {
  value = data.helm_template.this
}