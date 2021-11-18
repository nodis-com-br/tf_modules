locals {
  default_action_values = {
    redirect = {
      path = "/#{path}"
      port = "443"
      protocol = "HTTPS"
      query = "#{query}"
      status_code = "HTTP_301"
    }
  }
}