resource "google_project_iam_binding" "project3" {
  project = "your-project-id"
  role    = "roles/apigee.runtimeAgent"

  members = [
    "user:jane@example.com",
  ]

  condition {
    title       = "expires_after_2019_12_31"
    description = "Expiring at midnight of 2019-12-31"
    expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
  }
}

resource "google_project_iam_member" "project4" {
  project = "your-project-id"
  role    = "roles/apigee.runtimeAgent"
  member  = "user:jane@example.com"
}
