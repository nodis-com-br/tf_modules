resource "github_repository_file" "this" {
  for_each            = var.repository != null ? local.branches_by_name : local.branches_by_topic
  repository          = each.value["repo"]
  branch              = each.value["branch"]
  file                = var.file
  content             = var.content
  commit_message      = "chore: ${var.file} modified by terraform - skip_ci"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.email_domain}"
  overwrite_on_create = var.overwrite_on_create
}