variable "name" {}

variable "backend" {}

variable "secret_type" {
  default = "service_account_key"
}

variable "token_scopes" {
  default = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "project" {
  type = object({
    name = string
    project_id = string
  })
}

variable "roles" {
  type = list(string)
}