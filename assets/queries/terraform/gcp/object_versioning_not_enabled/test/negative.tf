resource "google_storage_bucket" "negative1" {
  name     = "foo"
  location = "EU"

  versioning = {
    enabled = true
  }
}