resource "google_container_cluster" "negative1" {
  name     = "gke-network-policy-cluster"
  location = "us-central1"

  initial_node_count = 3

  network_policy {
    enabled  = true
  }
}

resource "google_container_cluster" "negative2" {
  name     = "gke-network-policy-cluster"
  location = "us-central1"

  initial_node_count = 3

  network_policy {
    enabled  = true
    provider = "CALICO"
  }
}
