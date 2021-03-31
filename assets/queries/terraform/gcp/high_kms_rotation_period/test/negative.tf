resource "google_kms_crypto_key" "negative1" {
  name            = "crypto-key-example"
  key_ring        = "some-key-ring"
  rotation_period = "100000s"
}