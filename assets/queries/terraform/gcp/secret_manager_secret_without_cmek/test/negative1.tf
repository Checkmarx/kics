resource "google_secret_manager_secret" "negative1" {
  secret_id = "my-secret"
  replication {
    user_managed {
      replicas {
        location = "us-central1"
        customer_managed_encryption {
          kms_key_name = google_kms_crypto_key.example.id
        }
      }
    }
  }
}
