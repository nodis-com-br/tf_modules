resource "vault_pki_secret_backend_role" "this" {
  backend = var.backend
  name = var.name
  ttl = var.ttl
  key_type = var.key_type
  key_bits = var.key_bits
  allow_ip_sans = var.allow_ip_sans
  allowed_domains  = var.allowed_domains
  allow_subdomains = var.allow_subdomains
  allow_bare_domains = var.allow_bare_domains
  allow_glob_domains = var.allow_glob_domains
  allow_any_name = var.allow_any_name
  key_usage = var.key_usage
}