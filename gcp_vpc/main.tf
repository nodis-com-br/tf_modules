resource "google_compute_network" "this" {
  provider = google.current
  name = var.name
  auto_create_subnetworks = var.auto_create_subnetworks
  routing_mode = var.routing_mode
}

resource "google_compute_subnetwork" "public" {
  provider = google.current
  for_each = toset(data.google_compute_regions.this.names)
  name = "public-${index(data.google_compute_regions.this.names, each.key)}"
  ip_cidr_range = cidrsubnet(var.ipv4_cidr, var.subnet_newbits, index(data.google_compute_regions.this.names, each.key))
  region = each.value
  network = google_compute_network.this.id
  log_config {
    aggregation_interval = var.log_config_aggregation_interval
    flow_sampling = var.log_config_flow_sampling
    metadata = var.log_config_metadata
  }
}