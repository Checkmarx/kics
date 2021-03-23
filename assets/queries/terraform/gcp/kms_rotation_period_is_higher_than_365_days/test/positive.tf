resource "google_kms_crypto_key" "positive1" {
  name            = "crypto-key-example"
  key_ring        = "some-key-ring"
  rotation_period = "32000000s"
}

resource "google_kms_crypto_key" "positive2" {
  name            = "crypto-key-example"
  key_ring        = "some-key-ring"
}