variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "builtin_redirectors" {
  type = list(string)
  default = []
}

variable "redirectors" {
  default = {}
}

variable "forwarders" {
  default = {}
}

variable "listeners" {
  default = {}
}

variable "builtin_listeners" {
  type = list(string)
  default = []
}


variable "log_bucket_name" {}