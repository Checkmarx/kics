resource "google_container_cluster" "positive3" {
  name     = "my-gke-cluster"
  location = "us-central1"
  initial_node_count       = 1
  release_channel {
    channel = "RAPID"
  }
}