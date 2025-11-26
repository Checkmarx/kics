resource "google_container_node_pool" "negative8" {
  name       = "my-node-pool"
  cluster    = google_container_cluster.primary.id
  node_count = 1
}