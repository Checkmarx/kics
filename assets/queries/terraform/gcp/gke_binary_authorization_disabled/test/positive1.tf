resource "google_container_cluster" "fail" {
  name     = "my-gke-cluster"
  location = "us-central1"

  binary_authorization {
    evaluation_mode = "DISABLED"
  }
}
