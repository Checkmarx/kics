resource "google_project_iam_binding" "project" {
  project = "your-project-id"
  role    = "roles/iam.serviceAccountTokenCreator"

  members = [
    "user:jane@example.com",
    "serviceAccount:my-other-app@appspot.gserviceacccount.com"
  ]
}

resource "google_project_iam_binding" "project2" {
  project = "your-project-id"
  role    = "roles/iam.serviceAccountTokenCreator"
  member = "serviceAccount:my-other-app@appspot.gserviceacccount.com"
}

resource "google_project_iam_binding" "project3" {
  project = "your-project-id"
  role    = "roles/iam.serviceAccountUser"

  members = [
    "user:jane@example.com",
    "serviceAccount:my-other-app@appspot.gserviceacccount.com"
  ]
}

resource "google_project_iam_binding" "project4" {
  project = "your-project-id"
  role    = "roles/iam.serviceAccountUser"
  member = "serviceAccount:my-other-app@appspot.gserviceacccount.com"
}