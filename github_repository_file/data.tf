data "github_repositories" "by_topic" {
  for_each = toset(var.topics)
  query = "${each.value} in:topics org:${var.owner} archived:false"
}

data "github_repository" "by_topic" {
  for_each = toset(flatten([for t in var.topics : [for r in data.github_repositories.by_topic[t].names : r]]))
  name = each.value
}

data "github_repository" "by_name" {
  count = var.repository != null ? 1 : 0
  name = var.repository
}