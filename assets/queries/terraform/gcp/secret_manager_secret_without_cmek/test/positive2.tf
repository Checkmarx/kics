resource "google_secret_manager_secret" "positive2" {
  secret_id = "my-secret"
  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
    }
  }
}
