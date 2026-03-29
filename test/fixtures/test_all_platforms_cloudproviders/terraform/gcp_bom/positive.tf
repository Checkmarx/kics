resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.bucket.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket" "bucket" {
  name     = "static-content-bucket"
  location = "US"
}


resource "google_storage_bucket_iam_binding" "binding" {
  bucket = google_storage_bucket.bucket2.name
  role = "roles/storage.admin"
  members = [
    "allUsers",
  ]
}

resource "google_storage_bucket" "bucket2" {
  name     = "static-content-bucket"
  location = "US"
  encryption {
    default_kms_key_name = "somekey"
  }
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.bucket3.name
  role = "roles/storage.admin"
  member = "user:jane@example.com"
}

resource "google_storage_bucket" "bucket3" {
  name     = "static-content-bucket"
  location = "US"
}
