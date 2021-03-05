resource "google_compute_project_metadata" "negative1" {
  metadata = {
    enable-oslogin = true
  }
}
