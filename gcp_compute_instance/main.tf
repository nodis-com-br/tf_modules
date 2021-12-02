resource "google_compute_instance" "this" {
  provider = google.current
  count = var.host_count
  name = "${var.name}${format("%04.0f", count.index + 1)}"
  hostname = "${var.name}${format("%04.0f", count.index + 1)}"
  machine_type = var.machine_type
  zone = var.zone
  tags = var.tags
  allow_stopping_for_update = var.allow_stopping_for_update
  deletion_protection = var.deletion_protection
  boot_disk {
    initialize_params {
      image = var.boot_disk_image
      size = var.boot_disk_size
    }
  }
  network_interface {
    network = var.network
    subnetwork = var.subnetwork
    dynamic "access_config" {
      for_each = var.access_config
      content {
        nat_ip = access_config.value.nat_ip
        network_tier = access_config.value.network_tier
      }
    }
  }
  guest_accelerator {
    count = var.guest_accelerator_count
    type = var.guest_accelerator_type
  }
}