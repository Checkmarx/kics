resource "google_access_approval_project_settings" "empty_settings" {
  project_id = "some-project-id"
  # FAIL: No tiene enrolled_services
}