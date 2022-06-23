variable "name" {}

variable "rg" {}

variable "auto_grow_enable" {
  type = bool
  default = true
}

variable "storage_size_gb" {
  type = number
  default = 20
}

variable "storage_iops" {
  default = 360
}

variable "backup_retention_days" {
  type = number
  default = 30
}

variable "admin_username" {
  type = string
  default = "mysql_admin"
}

variable "mysql_version" {
  default = "8.0.21"
}

variable "sku_name" {
  default = "Standard_B1s"
}

variable "subnet_id" {
  default = null
}

variable "private_dns_zone" {
  type = object({
    name = string
    id = string
  })
  default = null
}

variable "zone" {
  default = null
}