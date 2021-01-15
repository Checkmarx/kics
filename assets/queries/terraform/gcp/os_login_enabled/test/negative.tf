#this code is a correct code for which the query should not find any result
resource "google_compute_project_metadata" "login_true" {
  metadata = {
    enable-oslogin = true
  }
}