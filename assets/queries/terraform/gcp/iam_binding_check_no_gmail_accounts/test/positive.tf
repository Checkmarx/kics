resource "google_project_iam_binding" "positive1" {
  project = "your-project-id"
  role    = "roles/editor"

  members = [
    "user:jane@gmail.com",
  ]
}