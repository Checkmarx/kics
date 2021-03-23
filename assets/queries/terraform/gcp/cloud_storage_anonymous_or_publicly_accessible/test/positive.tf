#this is a problematic code where the query should report a result(s)
resource "google_storage_bucket_iam_binding" "positive1" {
  bucket = google_storage_bucket.default.name
  role = "roles/storage.admin"
  members = []
}

resource "google_storage_bucket_iam_binding" "positive2" {
  bucket = google_storage_bucket.default.name
  role = "roles/storage.admin"
  members = ["user:jane@example.com","allUsers"]
}

resource "google_storage_bucket_iam_binding" "positive3" {
  bucket = google_storage_bucket.default.name
  role = "roles/storage.admin"
  members = ["user:jane@example.com", "allAuthenticatedUsers"]
}