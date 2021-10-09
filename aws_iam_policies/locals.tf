locals {
  policy_files = [for s in fileset(var.policy_folder, "*.json") : replace(basename(s), ".json", "")]
}