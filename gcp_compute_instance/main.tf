resource "time_static" "creation" {}

resource "google_compute_disk" "this" {
  provider = google.current
  for_each = local.attached_disks
  name = each.key
  type = each.value.type
  zone = each.value.zone
  image = each.value.image
  labels = each.value.labels
  size = each.value.size
}

resource "google_compute_resource_policy" "this" {
  provider = google.current
  count = anytrue(local.policy_conditions) ? 1 : 0
  name = var.name
  region = var.region
  dynamic "instance_schedule_policy" {
    for_each = var.instance_schedule_policy == null ? {} : {this = var.instance_schedule_policy}
    content {
      start_time = timeadd(time_static.creation.rfc3339, "1h")
      time_zone = instance_schedule_policy.value.time_zone
      dynamic vm_start_schedule {
        for_each = instance_schedule_policy.value.vm_start == null ? {} : {this = instance_schedule_policy.value.vm_start}
        content {
          schedule = vm_start_schedule.value
        }
      }
      dynamic vm_stop_schedule {
        for_each = instance_schedule_policy.value.vm_stop == null ? {} : {this = instance_schedule_policy.value.vm_stop}
        content {
          schedule = vm_stop_schedule.value
        }
      }
    }
  }
}


resource "google_compute_address" "static" {
  provider = google.current
  count = var.static_public_ip ? var.host_count : 0
  name = "${var.name}${format("%04.0f", count.index + 1)}"
  region = var.region
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
    for_each = {for k, v in local.attached_disks : k => v if v.host_index == count.index}
    content {
      source = google_compute_disk.this[attached_disk.key].self_link
    }
  }
  network_interface {
    network = var.network.name
    subnetwork = var.subnetwork.name
    dynamic "access_config" {
      for_each = var.static_public_ip ? {this = {nat_ip = google_compute_address.static[count.index].address}} : {}
      content {
        nat_ip = access_config.value.nat_ip
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
  metadata = {
    ssh-keys = var.ssh_keys
  }
//  service_account {
//    email  = module.service_account.this.email
//    scopes = ["cloud-platform"]
//  }
}