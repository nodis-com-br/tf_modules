variable "project" {}

variable "name" {}

variable "num_shards" {
  default = 1
}

variable "replication_factor" {
  default = 3
}

variable "cloud_backup" {
  default = true
}

variable "auto_scaling_disk_gb_enabled" {
  default  = true
}

variable "mongo_db_major_version" {
  default = "4.4"
}

variable "provider_disk_type_name" {
  default = "P4"
}

variable "provider_instance_size_name" {
  default = "M10"
}

variable "provider_name" {
  default = "AZURE"
}

variable "provider_region_name" {
  default = "US_EAST"
}

