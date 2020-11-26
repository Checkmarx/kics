resource "google_project_iam_member" "project" {
  project = "your-project-id"
  role    = "roles/editor"
  members  = "user:jane@example.com"
}