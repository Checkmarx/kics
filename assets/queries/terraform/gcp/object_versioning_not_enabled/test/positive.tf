resource "google_storage_bucket" "foo" {
  name     = "foo"
  location = "EU"

  versioning = {
    enabled = "false"
  }
}

resource "google_storage_bucket" "foo2" {
  name     = "foo"
  location = "EU"
}