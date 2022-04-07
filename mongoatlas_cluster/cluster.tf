resource "mongodbatlas_cluster" "this" {
  project_id = var.project.id
  name = var.name
  num_shards = var.num_shards
  replication_factor = var.replication_factor
  auto_scaling_compute_enabled = var.auto_scaling_compute_enabled
  auto_scaling_disk_gb_enabled = var.auto_scaling_disk_gb_enabled
  mongo_db_major_version = var.mongo_db_major_version
  provider_name = var.provider_name
  provider_disk_type_name  = var.provider_disk_type_name
  provider_instance_size_name = var.provider_instance_size_name
  provider_region_name = var.provider_region_name
  cloud_backup = var.cloud_backup
  lifecycle {
    ignore_changes = [
      snapshot_backup_policy,
      bi_connector,
      provider_disk_type_name,
      state_name
    ]
  }
}

