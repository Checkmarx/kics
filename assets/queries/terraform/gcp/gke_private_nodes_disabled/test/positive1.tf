resource "google_container_cluster" "fail" {
  name     = "my-gke-cluster"
  location = "us-central1"

  private_cluster_config {
    enable_private_nodes    = false
    enable_private_endpoint = false
  }
}
