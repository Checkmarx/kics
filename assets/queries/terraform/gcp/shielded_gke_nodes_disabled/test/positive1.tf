resource "google_container_cluster" "unset" {
  name                  = "my-gke-cluster"
  location              = "us-central1"
  remove_default_node_pool = true
  initial_node_count       = 1
}
