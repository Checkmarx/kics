data "google_iam_policy" "admin" {
  binding {
    role = "roles/admin"
    members = [
      "serviceAccount:your-custom-sa@your-project.iam.gserviceaccount.com",
    ]
  }
  binding {
    role = "roles/editor"
    members = [
      "serviceAccount:alice@gmail.com",
    ]
  }
}
