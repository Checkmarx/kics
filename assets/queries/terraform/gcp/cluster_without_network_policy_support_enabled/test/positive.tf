resource "google_container_cluster" "positive1" {
  name     = "gke-network-policy-cluster"
  location = "us-central1"

  initial_node_count = 3

  # missing "network_policy"
}

resource "google_container_cluster" "positive2" {
  name     = "gke-network-policy-cluster"
  location = "us-central1"

  initial_node_count = 3

  network_policy {
    enabled  = false
  }
}
