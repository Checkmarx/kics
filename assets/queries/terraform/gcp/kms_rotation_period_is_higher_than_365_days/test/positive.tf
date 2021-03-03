resource "google_kms_crypto_key" "long-period" {
  name            = "crypto-key-example"
  key_ring        = "some-key-ring"
  rotation_period = "32000000s"
}

resource "google_kms_crypto_key" "no-period" {
  name            = "crypto-key-example"
  key_ring        = "some-key-ring"
}