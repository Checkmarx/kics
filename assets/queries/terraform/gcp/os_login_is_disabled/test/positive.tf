resource "google_compute_project_metadata" "positive1" {
  metadata = {
    enable-oslogin = false
  }
}

resource "google_compute_project_metadata" "positive2" {
  metadata = {
      foo  = "bar"
  }
}
