variable "path" {}

variable "type" {
  default = "kubernetes"
}

variable "host" {}

variable "service_account_name" {
  default = "vault-secrets-backend"
}

variable "service_account_namespace" {
  default = "kube-system"
}

variable "admin_role" {
  default = "cluster-admin"
}

variable "editor_role" {
  default = "edit"
}

variable "viewer_role" {
  default = "view"
}

variable "default_ttl" {
  default = null
}

variable "max_ttl" {
  default = null
}