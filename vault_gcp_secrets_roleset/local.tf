locals {
  token_scopes = var.secret_type == "access_toke" ? var.token_scopes : null
}