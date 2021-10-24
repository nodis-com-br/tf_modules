variable "vault_addr" {}

variable "path" {
  default = "azure"
}

variable "environment" {
  default = "AzurePublicCloud"
}

variable "service_principal_name" {
  default = "vault-secrets"
}