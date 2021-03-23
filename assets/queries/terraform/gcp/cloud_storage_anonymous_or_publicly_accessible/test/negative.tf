#this code is a correct code for which the query should not find any result
resource "google_storage_bucket_iam_binding" "negative1" {
  bucket = google_storage_bucket.default.name
  role = "roles/storage.admin"
  members = [
    "user:jane@example.com",
  ]
}