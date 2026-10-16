resource "google_secret_manager_secret" "positive1" {
  secret_id = "my-secret"
  replication {
    auto {}
  }
}
