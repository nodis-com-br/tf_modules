variable "name" {}

variable "host_count" {
  default = 1
}

variable "ami" {}

variable "type" {
  default = "t3a.micro"
}

variable "key_name" {}

variable "subnets" {
  type = list(object({
    id = string
    vpc_id = string
  }))
}

variable "root_volume" {
  default = {
    volume_type = "gp2"
    volume_size = 20
    delete_on_termination = true
  }
}

variable "tags" {}

variable source_dest_check {
  default = "true"
}

variable "ingress_rules" {
  type = map(object({
    security_groups = list(string)
    protocol = string
    from_port = number
    to_port = number
    cidr_blocks = list(string)
  }))
}

variable "builtin_ingress_rules" {
  default = []
}

variable "egress_rules" {
  type = map(object({
    security_groups = list(string)
    protocol = string
    from_port = number
    to_port = number
    cidr_blocks = list(string)
  }))
}

variable "builtin_egress_rules" {
  default = ["all"]
}

variable "dns_record" {
  default = null
}

variable "iam_instance_profile" {
  default = false
}