resource "google_container_node_pool" "negative1" {
  name       = "my-node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name
  node_count = 3

  management {
    auto_upgrade = true
  }

  timeouts {
    create = "30m"
    update = "20m"
  }
}