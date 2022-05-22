data "kubernetes_secret" "this" {
  provider = kubernetes
  metadata {
    name = "${module.elasticsearch.this.name}-es-elastic-user"
    namespace = module.elasticsearch.this.namespace
  }
}

data "kubernetes_service" "this" {
  provider = kubernetes
  metadata {
    name = "${module.elasticsearch.this.name}-es-http"
    namespace = module.elasticsearch.this.namespace
  }
}