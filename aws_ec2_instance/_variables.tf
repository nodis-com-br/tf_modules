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

variable "volumes" {
  default = {}
  type = map(object({
    size = string
  }))
}

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

variable "egress_rules" {
  type = map(object({
    security_groups = list(string)
    protocol = string
    from_port = number
    to_port = number
    cidr_blocks = list(string)
  }))
  default = {
    all = {
      security_groups = []
      protocol = -1
      from_port = 0
      to_port = 0
      cidr_blocks = [
        "0.0.0.0/0"]
    }
  }
}

variable "dns_record" {
  default = null
}
