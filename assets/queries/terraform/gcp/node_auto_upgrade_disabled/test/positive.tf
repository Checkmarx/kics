resource "google_container_node_pool" "positive1" {
  name       = "my-node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name
  node_count = 3

  timeouts {
    create = "30m"
    update = "20m"
  }
}

resource "google_container_node_pool" "positive2" {
  name       = "my-node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name
  node_count = 3

  management {
    auto_repair = true
  }

  timeouts {
    create = "30m"
    update = "20m"
  }
}

resource "google_container_node_pool" "positive3" {
  name       = "my-node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name
  node_count = 3

  management {
    auto_upgrade = false
  }

  timeouts {
    create = "30m"
    update = "20m"
  }
}
