variable "project" {
  type = object({
    name = string
    project_id = string
  })
}

variable "path" {
  default = "gcp"
}