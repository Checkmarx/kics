resource "google_project_iam_binding" "project5" {
  role = "roles/viewer"

  members = [
    "serviceAccount:jane@example.com",
  ]
}

data "google_iam_policy" "policy6" {
  binding {
    role = "roles/viewer"

    members = [
      "user:jane@example.com",
    ]
  }
}
