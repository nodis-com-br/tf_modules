data "kubernetes_secret" "default_user" {
  provider = kubernetes
  count = var.enable_vault ? 0 : 1
  metadata {
    name = "${module.rabbitmq.this.name}-default-user"
    namespace = module.rabbitmq.this.namespace
  }
}