resource "google_container_cluster" "negative6" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  min_master_version = "1.11.8-gke.5" # gke version higher than 1.10

  addons_config {}
}