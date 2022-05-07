variable "org" {}

variable "name" {}

variable "name_prefix" {
  default = "nodis"
}

variable "provider_name" {
  default = "AZURE"
}

variable "provider_region_name" {
  default = "US_EAST"
}

variable "atlas_cidr_block" {
  default = null
}

variable "peering" {
  default = null
}

variable "ip_access_list" {
  default = {}
}