locals {
  attached_disks = {for disk in flatten([
    for host_index in range(var.host_count) : [
      for k, v in var.attached_disks : {
        basename = k
        fullname = "${var.name}${format("%04.0f", host_index + 1)}-${k}"
        host_index = host_index
        type = try(v.type, null)
        zone = try(v.zone, null)
        image = try(v.image, null)
        labels = try(v.labels, null)
        size = try(v.size, null)
      }
    ]
  ]) : disk.fullname => disk}
  policy_conditions = [
    var.instance_schedule_policy != null
  ]
}