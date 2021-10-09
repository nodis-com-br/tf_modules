provider "postgresql" {
  host = azurerm_private_endpoint.this.0.private_service_connection.0.private_ip_address
  port = 5432
  username = "${var.admin_username}@${local.name}"
  password = random_password.postgres_password.result
  superuser = false
}

provider "aws" {
  access_key = data.vault_aws_access_credentials.terraform.access_key
  secret_key = data.vault_aws_access_credentials.terraform.secret_key
  region = "us-east-1"
}