variable "name" {}

variable "enable_key_rotation" {
  default = true
}

variable "deletion_window_in_days" {
  default = 10
}

variable "access_key" {
  default = true
  type = bool
}

variable "username" {
  default = null
}