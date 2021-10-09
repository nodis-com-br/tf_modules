data "vault_aws_access_credentials" "terraform" {
  backend = "aws"
  role = "terraform"
}

data "vault_generic_secret" "token" {
  path = "auth/token/lookup"
}