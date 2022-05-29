output "kubernetes_secret_backend" {
  value = "${var.vault_backend_type}/${var.cluster.this.name}"
}

output "kubernetes_auth_backend" {
  value = "${var.vault_backend_type}/${var.cluster.this.name}"
}