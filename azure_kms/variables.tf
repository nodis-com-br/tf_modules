variable "name" {}

variable "rg" {}

variable "azure_config" {
  type = object({
    tenant_id = string
    object_id = string
  })
}

