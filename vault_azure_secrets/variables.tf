variable "environment" {
  default = "AzurePublicCloud"
}

variable "service_principal_name" {
  default = "vault-secrets"
}

variable "service_principal_roles" {}

variable "service_principal_resource_accesses" {}

variable "subscription_id" {}

variable "tenant_id" {}