resource "google_container_cluster" "negative4" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
}  