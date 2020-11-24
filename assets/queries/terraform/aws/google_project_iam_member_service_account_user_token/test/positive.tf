resource "google_project_iam_member" "project" {
  project = "your-project-id"
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:my-other-app@appspot.gserviceacccount.com"
}

resource "google_project_iam_member" "project2" {
  project = "your-project-id"
  role    = "roles/iam.serviceAccountUser"
  members  = ["user:jane@example.com", "serviceAccount:my-other-app@appspot.gserviceacccount.com"]
}