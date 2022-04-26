variable "name" {}

variable "backend" {
  type = object({
    path = string
  })
}

variable "db_name" {}

variable "creation_statements" {
  type = list(string)
}