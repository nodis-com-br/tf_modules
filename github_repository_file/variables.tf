variable "owner" {}

variable "topics" {
  default = []
}

variable "repository" {
  default = null
}

variable "file" {}

variable "content" {}

variable "email_domain" {}

variable "overwrite_on_create" {
  default = true
}