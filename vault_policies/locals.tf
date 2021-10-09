locals {
  policy_files = [for s in fileset(var.policy_folder, "*.hcl") : replace(basename(s), ".hcl", "")]
}