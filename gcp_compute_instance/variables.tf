variable "name" {}

variable "host_count" {
  default = 1
}

variable "machine_type" {
  default = "e2-medium"
}

variable "region" {}

variable "zone" {
  default = "us-central1-a"
}

variable "tags" {
  type = list(string)
  default = []
}

variable "boot_disk_image" {
  default = "debian-cloud/debian-11"
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
  default = ""
}

variable "deletion_protection" {
  default = true
}

variable "hostname" {
  default = null
}

variable "network" {
  default = {name = null}
}

variable "subnetwork" {
  default = {name = null}
}

variable "access_config" {
  type = list(object({
    nat_ip = string
    network_tier = string
  }))
  default = [{
    nat_ip = null
    network_tier = null
  }]
}

variable "can_ip_forward" {
  default = false
}

variable "attached_disks" {
  default = {}
}

variable "instance_schedule_policy" {
  type = object({
    vm_start = string
    vm_stop = string
    time_zone = string
  })
  default = null
}