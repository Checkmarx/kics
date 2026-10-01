resource "google_project" "safe_project" {
  name       = "Safe Project"
  project_id = "safe-123"
  org_id     = "12345"
}

resource "google_access_approval_project_settings" "safe_settings" {
  project_id = google_project.safe_project.project_id

  enrolled_services {
    cloud_product = "all"
  }
}