output "this" {
  value = module.elasticsearch.this
}

output "credentials" {
  sensitive = true
  value = {
    username = "elastic"
    password = try(data.kubernetes_secret.this.data.elastic, null)
    url = try("${var.schema}://${data.kubernetes_service.this.metadata[0].annotations["nodis.com.br/managed-domain"]}:${var.port}", null)
  }
}

output "vault_secrets_backend" {
  value = module.vault_secrets_backend.this.path
}