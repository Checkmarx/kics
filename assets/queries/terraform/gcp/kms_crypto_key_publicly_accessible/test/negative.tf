resource "google_kms_key_ring" "negative" {
  name     = "negative-example"
  location = "global"
}
resource "google_kms_crypto_key" "negative" {
  name            = "crypto-key-example"
  key_ring        = google_kms_key_ring.negative.id
  rotation_period = "100000s"
  lifecycle {
    prevent_destroy = true
  }
}

data "google_iam_policy" "negative" {
  binding {
    role = "roles/cloudkms.cryptoKeyEncrypter"

    members = [
      "user:jane@example.com",
    ]
  }
}

resource "google_kms_crypto_key_iam_policy" "negative" {
  crypto_key_id = google_kms_crypto_key.negative.id
  policy_data = data.google_iam_policy.negative.policy_data
}
