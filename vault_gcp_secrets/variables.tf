variable "project" {
  type = object({
    name = string
    project_id = string
  })
}

variable "path" {
  default = "gcp"
}

variable "default_lease_ttl_seconds" {
  default = null
}

variable "max_lease_ttl_seconds" {
  default = null
}