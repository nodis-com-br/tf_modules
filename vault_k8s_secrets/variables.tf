variable "path" {}

variable "type" {
  default = "vault-k8s-secret-engine"
}

variable "host" {}

variable "jwt" {}

variable "ca_cert" {}

variable "admin_role" {
  default = "admin"
}

variable "editor_role" {
  default = "editor"
}

variable "viewer_role" {
  default = "viewer"
}

variable "max_ttl" {
  default = "768h"
}