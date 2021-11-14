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

variable "log_bucket_name" {}