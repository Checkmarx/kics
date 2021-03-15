resource "google_project_iam_member" "positive1" {
  project = "your-project-id"
  role    = "roles/iam.serviceAccountAdmin"
  member  = "serviceAccount:my-other-app@appspot.gserviceacccount.com"
}

resource "google_project_iam_member" "positive2" {
  project = "your-project-id"
  role    = "roles/iam.serviceAccountAdmin"
  members  = ["user:jane@example.com", "serviceAccount:my-other-app@appspot.gserviceacccount.com"]
}
