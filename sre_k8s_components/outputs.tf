output "kubernetes_secret_backend" {
  value = "kubernetes/${var.cluster.this.name}"
}

output "kubernetes_auth_backend" {
  value = "kubernetes/${var.cluster.this.name}"
}