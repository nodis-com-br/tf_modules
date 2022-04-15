output "this" {
  value = {
    path = module.auth_backend.this.path
    type = module.auth_backend.this.type
  }
}