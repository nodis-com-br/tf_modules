output "this" {
  value = module.elasticsearch.this
}

output "credentials" {
  sensitive = true
  value = {
    url = "${var.schema}://${try(data.kubernetes_service.this.metadata[0].annotations["nodis.com.br/managed-domain"], data.kubernetes_service.this.spec[0].load_balancer_ip)}:${var.port}"
    username = "elastic"
    password = data.kubernetes_secret.this.data.elastic
  }
}

output "vault_secrets_backend" {
  value = module.vault_secrets_backend.this.path
}