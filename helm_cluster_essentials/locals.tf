locals {
  default_values = {
    kong_default_override = jsonencode({
      route = {
        protocols = ["https"]
        https_redirect_status_code = 302
        strip_path = true
      }
    })
  }
}

