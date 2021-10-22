variable "path" {
  default = "kubernetes"
}

variable "host" {}

variable "ca_certificate" {}

variable "token" {}

variable "token_reviewer_sa" {
  type = object({
    namespace = string
    name = string
  })
  default = {
    name = "vault-injector"
    namespace = "vault-injector"
  }
}