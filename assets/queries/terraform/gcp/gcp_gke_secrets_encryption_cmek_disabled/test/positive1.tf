resource "google_container_cluster" "fail_missing_block" {
  name     = "no-encryption-block"
  location = "us-central1"
  # FAIL: database_encryption Does not exist
}