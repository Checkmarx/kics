resource "google_storage_bucket" "foo" {
  name     = "foo"
  location = "EU"

  versioning = {
    enabled = true
  }
}