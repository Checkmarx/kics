resource "google_project_iam_binding" "project1" {
  project = "your-project-id"
  role    = "roles/container.admin"

  members = [
    "serviceAccount:jane@example.com",
  ]

  condition {
    title       = "expires_after_2019_12_31"
    description = "Expiring at midnight of 2019-12-31"
    expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
  }
}

resource "google_project_iam_member" "project2" {
  project = "your-project-id"
  role    = "roles/editor"
  member  = "serviceAccount:jane@example.com"
}
