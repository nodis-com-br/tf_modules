### Required variables ################

variable "name" {}

variable "rg" {}

variable "subnet" {}

variable "admin_password" {}

variable "boot_diagnostics_storage_account" {}

variable "route53_zone_id" {}


### Null variables ####################

variable "source_image_reference" {
  default = null
}

variable "source_image_id" {
  default = null
}

variable "plan" {
  default = null
}

variable "public_domain" {
  default = null
}


### Defaulted varables ################

variable "admin_username" {
  default = "nodis"
}

variable "license_type" {
  default = "Windows_Server"
}

variable "size" {
  default = "Standard_B2s"
}

variable "private_domain" {
  default = "azurevm.nodis.com.br"
}

variable "public_access" {
  default = false
  type = bool
}

variable "host_count" {
  default = 1
  type = number
}

variable "snapshot" {
  default = "true"
  type = string
}

variable "extra_disks" {
  default = {}
}

variable "ingress_rules" {
  default = {}
}

variable "tags" {
  default = {}
}

variable "high_avaliability" {
  default = false
  type = bool
}

variable "load_balancer" {
  default = false
  type = bool
}

variable "enable_automatic_updates" {
  default = true
  type = bool
}