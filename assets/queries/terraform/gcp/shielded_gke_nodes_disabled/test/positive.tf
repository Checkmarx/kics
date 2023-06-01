resource "google_container_cluster" "false" {
  name                  = "my-gke-cluster"
  location              = "us-central1"
  enable_shielded_nodes = false
}