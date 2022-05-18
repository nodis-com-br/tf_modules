locals {
  ttl = {
    _1m = 60
    _5m = 60 * 5
    _30m = 60 * 30
    _1h = 60 * 60
    _1d = 60 * 60 * 24
    _3d = 60 * 60 * 24 * 3
    _7d = 60 * 60 * 24 * 7
    _30d = 60 * 60 * 24 * 30
    _32d = 60 * 60 * 24 * 32
  }
  vault = {
    policy = {
      read = file("${path.module}/vault_policies/read_path.hcl")
      write = file("${path.module}/vault_policies/write_path.hcl")
      list = file("${path.module}/vault_policies/list_path.hcl")
      deny = file("${path.module}/vault_policies/deny_path.hcl")
      read2 = jsonencode({path = {"%[1]s" = {capabilities = ["read"]}}})
    }
  }
}