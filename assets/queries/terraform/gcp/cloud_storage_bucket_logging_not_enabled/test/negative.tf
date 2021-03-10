resource "google_storage_bucket" "negative1" {
  name          = "auto-expiring-bucket"
  location      = "US"
  force_destroy = true

  logging {
	logBucket = "example-logs-bucket"
  }

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}