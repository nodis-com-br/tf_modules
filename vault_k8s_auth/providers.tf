provider "kubernetes" {
  host = var.host
  cluster_ca_certificate = var.ca_certificate
  token = var.token
}
