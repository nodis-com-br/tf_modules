resource "google_compute_disk" "this" {
  provider = google.current
  for_each = var.attached_disks
  name = each.key
  type = try(each.value.type, null)
  zone = try(each.value.zone, null)
  image = try(each.value.image, null)
  labels = try(each.value.labels, null)
  size = try(each.value.size, null)
}



resource "google_compute_instance" "this" {
  provider = google.current
  count = var.host_count
  name = "${var.name}${format("%04.0f", count.index + 1)}"
  machine_type = var.machine_type
  zone = var.zone
  tags = var.tags
  allow_stopping_for_update = var.allow_stopping_for_update
  deletion_protection = var.deletion_protection
  can_ip_forward = var.can_ip_forward
  boot_disk {
    initialize_params {
      image = var.boot_disk_image
      size = var.boot_disk_size
    }
  }
  dynamic "attached_disk" {
    for_each =  var.attached_disks
    content {
      source = google_compute_disk.this[attached_disk.key].self_link
    }
  }
  network_interface {
    network = var.network.name
    subnetwork = var.subnetwork.name
    dynamic "access_config" {
      for_each = var.access_config
      content {
        nat_ip = access_config.value.nat_ip
        network_tier = access_config.value.network_tier
      }
    }
  }
  scheduling {
    on_host_maintenance = var.guest_accelerator_count == 0 ? null : "TERMINATE"
  }
  guest_accelerator {
    count = var.guest_accelerator_count
    type = var.guest_accelerator_type
  }
}