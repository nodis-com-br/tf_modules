variable "backend" {}

variable "name" {}

variable "ttl" {
  default = null
}

variable "key_type" {
  default = "rsa"
}

variable "key_bits" {
  default = 4096
}

variable "key_usage" {
  default = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment",
  ]
}

variable "allow_ip_sans" {
  default = true
}

variable "allowed_domains" {
  default = ["*"]
}

variable "allow_subdomains" {
  default = true
}

variable "allow_bare_domains" {
  default = true
}

variable "allow_glob_domains" {
  default = true
}

variable "allow_any_name" {
  default = true
}