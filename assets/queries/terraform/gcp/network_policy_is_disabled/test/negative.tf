#this code is a correct code for which the query should not find any result
resource "google_container_cluster" "negative1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  network_policy {
      enabled = true
  }
  addons_config {
    network_policy_config {
        disabled = false
    }
  }
  networking_mode = "VPC_NATIVE"

  timeouts {
    create = "30m"
    update = "40m"
  }
}