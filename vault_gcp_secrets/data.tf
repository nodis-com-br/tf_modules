data "vault_generic_secret" "token" {
  path = "auth/token/lookup"
}