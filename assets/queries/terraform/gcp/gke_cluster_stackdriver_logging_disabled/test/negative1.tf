resource "google_container_cluster" "pass" {
  name            = "my-cluster"
  location        = "us-central1"
  logging_service = "logging.googleapis.com/kubernetes"
}
