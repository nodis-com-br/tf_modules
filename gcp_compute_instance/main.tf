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

resource "google_compute_resource_policy" "this" {
  provider = google.current
  count = anytrue(local.policy_conditions) ? 1 : 0
  name = var.name
  region = var.region
  dynamic "instance_schedule_policy" {
    for_each = var.instance_schedule_policy == null ? {} : {this = var.instance_schedule_policy}
    content {
      vm_start_schedule {
        schedule = instance_schedule_policy.value.vm_start
      }
      vm_stop_schedule {
        schedule = instance_schedule_policy.value.vm_stop
      }
      time_zone = instance_schedule_policy.value.time_zone
    }
  }
}

resource "google_compute_instance" "this" {
  provider = google.current
  count = var.host_count
  name = "${var.name}${format("%04.0f", count.index + 1)}"
  machine_type = var.machine_type
  zone = var.zone
  tags = var.tags
  resource_policies = anytrue(local.policy_conditions) ? [google_compute_resource_policy.this.0.self_link] : null
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