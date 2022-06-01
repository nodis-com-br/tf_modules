variable "repository_name" {
  default = "s3"
}

variable "repository_type" {
  default = "s3"
}

variable "repository_settings" {}

variable "snapshot_schedule" {
  default = "0 0 0 * * ?"
}

variable "snapshot_name" {
  default = "<daily-snap-{now/d}>"
}

variable "snapshot_config" {
  default =  {
    indices = ["*"]
    ignore_unavailable = false,
    include_global_state = false
  }
}

variable "snapshot_retention" {
  default = {expire_after = "90d"}
}