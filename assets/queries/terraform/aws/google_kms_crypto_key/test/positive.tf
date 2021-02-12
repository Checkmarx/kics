resource "google_kms_crypto_key" "key" {
  name            = "crypto-key-example"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "77760009s"
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key" "key2" {
  name            = "crypto-key-example"
  key_ring        = google_kms_key_ring.keyring.id
  lifecycle {
    prevent_destroy = true
  }
}
