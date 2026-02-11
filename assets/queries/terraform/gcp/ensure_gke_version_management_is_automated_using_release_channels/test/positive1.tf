resource "google_container_cluster" "positive1" {
  name     = "my-gke-cluster"
  location = "us-central1"
  initial_node_count       = 1
}