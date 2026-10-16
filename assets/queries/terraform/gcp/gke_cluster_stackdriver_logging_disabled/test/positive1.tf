resource "google_container_cluster" "fail" {
  name            = "my-cluster"
  location        = "us-central1"
  logging_service = "none"
}
