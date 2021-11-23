resource "google_kms_key_ring" "positive1" {
  name     = "keyring-example"
  location = "global"
}
resource "google_kms_crypto_key" "positive1" {
  name            = "crypto-key-example"
  key_ring        = google_kms_key_ring.positive1.id
  rotation_period = "100000s"
  lifecycle {
    prevent_destroy = true
  }
}

data "google_iam_policy" "positive1" {
  binding {
    role = "roles/cloudkms.cryptoKeyEncrypter"

    member = "allUsers"
  }
}

resource "google_kms_crypto_key_iam_policy" "positive1" {
  crypto_key_id = google_kms_crypto_key.positive1.id
  policy_data = data.google_iam_policy.positive1.policy_data
}
