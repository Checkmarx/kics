resource "google_container_cluster" "negative1" {
  name = "marcellus-wallace"
  location = "us-central1-a"
  initial_node_count = 3
  private_cluster_config {
        enable_private_endpoint = true
        enable_private_nodes = true
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}
