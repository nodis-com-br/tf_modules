resource "google_compute_project_metadata" "this" {
  provider = google.current
  metadata = var.metadata
}
