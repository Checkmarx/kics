resource "google_container_node_pool" "fail" {
  name       = "my-node-pool"
  cluster    = google_container_cluster.primary.id
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = false
  }
}
