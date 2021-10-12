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
}