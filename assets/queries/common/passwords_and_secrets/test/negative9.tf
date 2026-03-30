# "Generic Secret" - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99 - negative-test (secret_(id) is not (key|value))
resource "google_secret_manager_secret" "secret-basic" {
  secret_id = "secret-version"

  labels = {
    label = "my-label"
  }

  replication {
    automatic = true
  }
}
