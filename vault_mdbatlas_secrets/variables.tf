variable "config" {
  type = object({
    organization_id = string
    public_key = string
    private_key = string
  })
  default = null
}