resource "google_container_cluster" "false" {
  name                  = "my-gke-cluster"
  location              = "us-central1"
  remove_default_node_pool = true
  initial_node_count       = 1
  enable_shielded_nodes = false
}