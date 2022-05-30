variable "type" {
  default = "kubernetes"
}

variable "path" {
  default = "kubernetes"
}

variable "service_account_name" {
  default = "vault-auth-backend"
}

variable "service_account_namespace" {
  default = "kube-system"
}

variable "host" {}