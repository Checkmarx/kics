resource "google_storage_bucket_iam_member" "positive1" {
  bucket = google_storage_bucket.default.name
  role = "roles/storage.admin"
  member = "allUsers"

  condition {
    title       = "expires_after_2019_12_31"
    description = "Expiring at midnight of 2019-12-31"
    expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
  }
}


resource "google_storage_bucket_iam_member" "positive2" {
  bucket = google_storage_bucket.default.name
  role = "roles/storage.admin"
  members = ["user:john@example.com","allAuthenticatedUsers"]
}