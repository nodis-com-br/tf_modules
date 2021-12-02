variable "name" {}

variable "auto_create_subnetworks" {
  default = false
}

variable "routing_mode" {
  default = "GLOBAL"
}

variable "ipv4_cidr" {}

variable "subnet_newbits" {
  default = 6
}

variable "log_config_aggregation_interval" {
  default = "INTERVAL_10_MIN"
}

variable "log_config_flow_sampling" {
  default = 0.5
}

variable "log_config_metadata" {
  default = "INCLUDE_ALL_METADATA"
}