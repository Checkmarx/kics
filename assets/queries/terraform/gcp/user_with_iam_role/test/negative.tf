data "google_iam_policy" "negative" {
  binding {
    role = "roles/apigee.runtimeAgent"

    members = [
      "group:jane@example.com",
    ]
  }
}
