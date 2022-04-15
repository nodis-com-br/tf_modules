variable "backend" {
  default = {path = ""}
  type = object({path = string})
}

variable "path" {}

variable "data_json" {}