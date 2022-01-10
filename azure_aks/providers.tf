provider "kubernetes" {
  host = local.credentials.host
  client_certificate = local.credentials.client_certificate
  client_key = local.credentials.client_key
  cluster_ca_certificate = local.credentials.cluster_ca_certificate
}
