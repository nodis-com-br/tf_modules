locals {
  extra_disks = {for disk in flatten([
    for host_index in range(var.host_count) : [
      for k, v in var.extra_disks : {
        basename = k
        fullname = "${var.rg.name}-${var.name}${format("%04.0f", host_index + 1)}-${k}"
        host_index = host_index
        storage_account_type = v.storage_account_type
        disk_size_gb = v.disk_size_gb
      }
    ]
  ]) : disk.fullname => disk}
  tags = merge({Snapshot = var.snapshot}, var.tags)
  source_image_reference = var.source_image_reference == null ? {} : {1 = var.source_image_reference}
  plan = var.plan == null ? {} : {1 = var.plan}
}