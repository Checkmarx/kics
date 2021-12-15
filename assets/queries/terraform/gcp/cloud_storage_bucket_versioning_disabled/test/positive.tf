resource "google_storage_bucket" "positive1" {
  name     = "foo"
  location = "EU"

  versioning = {
    enabled = false
  }
}

resource "google_storage_bucket" "positive2" {
  name     = "foo"
  location = "EU"
}