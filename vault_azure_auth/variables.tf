variable "tenant_id" {}

variable "path" {
  default = "azure"
}

variable "environment" {
  default = "AzurePublicCloud"
}

variable "service_principal_name" {
  default = "vault-auth"
}

variable "service_principal_resource_accesses" {}

variable "homepage_url" {
  default = "https://management.azure.com/"
}