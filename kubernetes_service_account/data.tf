data "kubernetes_service_account" "this" {
  provider = kubernetes
  metadata {
    name = kubernetes_service_account.this.metadata[0].name
    namespace = kubernetes_service_account.this.metadata[0].namespace
  }
}

data "kubernetes_secret" "this" {
  provider = kubernetes
  metadata {
    name = data.kubernetes_service_account.this.default_secret_name
    namespace = data.kubernetes_service_account.this.metadata[0].namespace
  }
}