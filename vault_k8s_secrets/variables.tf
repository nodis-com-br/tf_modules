variable "path" {}

variable "type" {
  default = "kubernetes"
}

variable "host" {}

variable "jwt" {}

variable "ca_cert" {}

variable "admin_role" {
  default = "cluster-admin"
}

variable "editor_role" {
  default = "edit"
}

variable "viewer_role" {
  default = "view"
}

variable "max_ttl" {
  default = "768h"
}