variable "name" {}

variable "host_count" {
  default = 1
}

variable "machine_type" {
  default = "e2-medium"
}

variable "zone" {
  default = "us-central1-a"
}

variable "tags" {
  type = list(string)
  default = []
}

variable "boot_disk_image" {
  image = "debian-cloud/debian-11"
}

variable "boot_disk_size" {
  default = null
}

variable "allow_stopping_for_update" {
  default = true
}

variable "guest_accelerator_count" {
  default = 0
}

variable "guest_accelerator_type" {
  default = null
}

variable "deletion_protection" {
  default = true
}

variable "hostname" {
  default = null
}

variable "network" {
  default = null
}

variable "subnetwork" {
  default = null
}

variable "network_interfaces" {
  default = {}
}

variable "access_config" {
  type = list(object({
    nat_ip = string
    network_tier = string
  }))
  default = [{
    nat_ip = null
    netwok_tier = null
  }]
}