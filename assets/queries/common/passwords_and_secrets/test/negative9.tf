resource "google_secret_manager_secret" "secret-basic" {
  secret_id = "secret-version"

  labels = {
    label = "my-label"
  }

  replication {
    automatic = true
  }
}
