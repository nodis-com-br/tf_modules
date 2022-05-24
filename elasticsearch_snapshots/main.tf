resource "elasticsearch_snapshot_repository" "this" {
  provider = elasticsearch
  name = var.repository_name
  type = var.repository_type
  settings = var.repository_settings
}

resource "elasticsearch_xpack_snapshot_lifecycle_policy" "this" {
  provider = elasticsearch
  name = var.repository_name
  body = jsonencode({
    schedule = var.snapshot_schedule
    name = var.snapshot_name
    repository = var.repository_name
    config = var.snapshot_config
    retention = var.snapshot_retention
  })
}