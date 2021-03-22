resource "google_project" "positive1" {
  name       = "My Project"
  project_id = "your-project-id"
  org_id     = "1234567"
  auto_create_network = true
}

resource "google_project" "positive2" {
  name       = "My Project"
  project_id = "your-project-id"
  org_id     = "1234567"
}
