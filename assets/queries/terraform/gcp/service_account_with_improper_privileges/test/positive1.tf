data "google_iam_policy" "admin" {
  binding {
    role = "roles/editor"

    members = [
      "serviceAccount:jane@example.com",
    ]
  }
}
