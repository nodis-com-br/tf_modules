resource "mongodbatlas_project" "this" {
  name = var.name
  org_id = var.org
}

resource "mongodbatlas_project_ip_access_list" "this" {
  for_each = var.ip_access_list
  project_id = mongodbatlas_project.this.id
  cidr_block = each.value
  comment = each.key
}

resource "mongodbatlas_network_container" "this" {
  count = var.peering == null ? 0 : 1
  project_id = mongodbatlas_project.this.id
  atlas_cidr_block = try(var.peering.atlas_cidr_block, null)
  provider_name = var.provider_name
  region = var.provider_region_name
}

resource "mongodbatlas_network_peering" "this" {
  count = var.peering == null ? 0 : 1
  project_id = mongodbatlas_project.this.id
  container_id = mongodbatlas_network_container.this.0.container_id
  provider_name = var.provider_name
  azure_directory_id = try(var.peering.azure_directory_id, null)
  azure_subscription_id = try(var.peering.azure_subscription_id, null)
  resource_group_name = try(var.peering.resource_group_name, null)
  vnet_name = try(var.peering.vnet_name, null)
}