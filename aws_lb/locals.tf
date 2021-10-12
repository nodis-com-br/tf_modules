locals {
  builtin_redirectors = {
    http_to_https = {
      port = 80
      protocol = "HTTP"
      action = {
        host = "#{host}"
        path = "/#{path}"
        port = "443"
        protocol = "HTTPS"
        query = "#{query}"
        status_code = "HTTP_301"
      }
    }
  }
  selected_builtin_redirectors = {for l in var.builtin_redirectors : r => local.builtin_redirectors[l]}
  redirectors = merge(var.redirectors, local.selected_builtin_redirectors)
}