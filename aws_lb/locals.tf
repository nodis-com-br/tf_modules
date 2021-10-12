locals {
  builtin_redirectors = {
    http_to_https = {
      port = 80
      protocol = "HTTP"
      action = {
        host = "#{host}"
      }
    }
  }
  selected_builtin_redirectors = {for l in var.builtin_redirectors : l => local.builtin_redirectors[l]}
  redirectors = merge(var.redirectors, local.selected_builtin_redirectors)
  target_group_attachments = {for target in flatten([
    for fk, fv in var.forwarders : [
      for t in fv.target_group.targets : {
        forwarder = fk
        id = t.id
      }
    ]
  ]) : target.id => target }
}