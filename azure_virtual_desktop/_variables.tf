variable "name" {}

variable "rg" {}

variable "validate_environment" {
  default = true
}

variable "start_vm_on_connect" {
  default= true
}

variable "custom_rdp_properties" {
  default = "audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:*;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:1;"
}

variable "type" {
  default = "Pooled"
}

variable "maximum_sessions_allowed" {
  default = 5
}

variable "load_balancer_type" {
  default = "DepthFirst"
}

variable "application_group_type" {
  default = "Desktop"
}
