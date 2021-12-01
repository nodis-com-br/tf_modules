output "this" {
  value = google_service_account.this
}

output "key" {
  value = var.account_key ? google_service_account_key.this.0 : null
}