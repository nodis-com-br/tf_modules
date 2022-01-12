resource "vault_aws_secret_backend_role" "role" {
  backend = var.backend
  name = var.name
  default_sts_ttl = var.credential_type == "iam_user" ? null : var.default_sts_ttl
  credential_type = var.credential_type
  policy_arns = var.policy_arns
  role_arns = var.role_arns
}