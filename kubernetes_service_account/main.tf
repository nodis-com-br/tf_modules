resource "kubernetes_service_account" "this" {
  provider = kubernetes
  metadata {
    name = var.name
    namespace = var.namespace
  }
  secret {
    name = kubernetes_secret.this.metadata.0.name
  }
}

resource "kubernetes_secret" "this" {
  provider = kubernetes
  metadata {
    name = "${var.name}-token"
    namespace = var.namespace
  }
}