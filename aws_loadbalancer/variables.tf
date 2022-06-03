variable "log_bucket_name" {}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "listeners" {
  default = {}
}

variable "builtin_listeners" {
  type = list(string)
  default = []
}