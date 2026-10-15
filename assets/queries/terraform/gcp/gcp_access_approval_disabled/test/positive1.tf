resource "google_project" "vulnerable_project" {
  name       = "Project Without Approval"
  project_id = "vulnerable-123"
  org_id     = "12345"
}