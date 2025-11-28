resource "google_container_cluster" "positive" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  addons_config {
    kubernetes_dashboard {
        disabled = false
    }
  }
}