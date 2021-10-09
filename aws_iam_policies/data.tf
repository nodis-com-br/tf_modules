data "local_file" "policy" {
  for_each = toset(local.policy_files)
  filename = "${var.policy_folder}/${each.value}.json"
}