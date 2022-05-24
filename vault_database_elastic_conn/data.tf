data "vault_generic_secret" "token" {
  path = "auth/token/lookup"
}

data "elasticsearch_host" "this" {
  active = true
}