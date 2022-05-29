data "external" "current_version" {
  program = ["${path.module}/scripts/git_get_latest_tag.sh", var.github_token, local.rendered_values["image"]["repository"], var.environment]
}