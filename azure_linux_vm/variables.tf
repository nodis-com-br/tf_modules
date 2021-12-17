variable "name" {}

variable "rg" {}

variable "subnet" {}

variable "admin_username" {
  default = "nodis"
}

variable "ssh_key" {}

variable "public_access" {
  default = false
  type = bool
}

variable "host_count" {
  type = number
  default = 1
}

variable "size" {
  default = "Standard_B1s"
}

variable "source_image_reference" {
  default = null
}

variable "source_image_id" {
  default = null
}

variable "plan" {
  default = null
}

variable "snapshot" {
  type = string
  default = "true"
}

variable "extra_disks" {
  default = {}
}

variable "ingress_rules" {
  default = {}
  type = map(object({
    protocol = string
    destination_port_range = string
    source_address_prefix = string
  }))
}

variable "tags" {
  default = {}
}

variable "high_avaliability" {
  type = bool
  default = false
}

variable "load_balancer" {
  type = bool
  default = false
}

variable "route53_zone" {
  type = object({
    id = string
    name = string
  })
}

variable "domain" {
  default = null
}

variable "private_domain" {
  default = "azurevm.nodis.com.br"
}

variable "boot_diagnostics_storage_account" {}

variable "sku_tier" {
  default = "Standard"
}

variable "identity_type" {
  default = "SystemAssigned"
}

variable "identity_ids" {
  type = list(string)
  default = null
}