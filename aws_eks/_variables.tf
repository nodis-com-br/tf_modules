variable "name" {}

variable "subnet_ids" {}

variable "ingress_rules" {
  type = map(object({
    protocol = string
    from_port = number
    to_port = number
    cidr_blocks = list(string)
  }))
}

variable "node_groups" {
  type = map(object({
    ssh_key = string
    tags = map(any)
    subnet_ids = list(string)
    instance_type = string
    desired_size = number
    max_size = number
    min_size = number
  }))
  default = {}
}

variable "sa_mappings" {
  type = list(object({
    service_account = string
    namespace = string
    policies = list(object({
      arn = string
      name = string
    }))
  }))
  default = []
}


