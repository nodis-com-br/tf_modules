data "kubernetes_secret" "default_user" {
  provider = kubernetes
  metadata {
    name = "${module.rabbitmq.this.name}-default-user"
    namespace = module.rabbitmq.this.namespace
  }
}