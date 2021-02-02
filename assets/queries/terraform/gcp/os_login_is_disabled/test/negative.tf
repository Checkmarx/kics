resource "google_compute_project_metadata" "login_true" {
  metadata = {
    enable-oslogin = true
  }
}
