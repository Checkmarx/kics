resource "google_pubsub_topic" "pass" {
  name        = "my-topic"
  kms_key_name = google_kms_crypto_key.key.id
}
