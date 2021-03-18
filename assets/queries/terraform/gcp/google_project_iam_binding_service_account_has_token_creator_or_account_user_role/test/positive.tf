resource "google_project_iam_binding" "positive1" {
  project = "your-project-id"
  role    = "roles/iam.serviceAccountTokenCreator"

  members = [
    "user:jane@example.com",
    "serviceAccount:my-other-app@appspot.gserviceacccount.com"
  ]
}

resource "google_project_iam_binding" "positive2" {
  project = "your-project-id"
  role    = "roles/iam.serviceAccountTokenCreator"
  member = "serviceAccount:my-other-app@appspot.gserviceacccount.com"
}

resource "google_project_iam_binding" "positive3" {
  project = "your-project-id"
  role    = "roles/iam.serviceAccountUser"

  members = [
    "user:jane@example.com",
    "serviceAccount:my-other-app@appspot.gserviceacccount.com"
  ]
}

resource "google_project_iam_binding" "positive4" {
  project = "your-project-id"
  role    = "roles/iam.serviceAccountUser"
  member = "serviceAccount:my-other-app@appspot.gserviceacccount.com"
}