resource "google_kms_key_ring" "positive2" {
  name     = "keyring-example"
  location = "global"
}
resource "google_kms_crypto_key" "positive2" {
  name            = "crypto-key-example"
  key_ring        = google_kms_key_ring.positive2.id
  rotation_period = "100000s"
  lifecycle {
    prevent_destroy = true
  }
}

data "google_iam_policy" "positive2" {
  binding {
    role = "roles/cloudkms.cryptoKeyEncrypter"

    member = "allAuthenticatedUsers"
  }
}

resource "google_kms_crypto_key_iam_policy" "positive2" {
  crypto_key_id = google_kms_crypto_key.keyyy.id
  policy_data = data.google_iam_policy.positive2.policy_data
}
