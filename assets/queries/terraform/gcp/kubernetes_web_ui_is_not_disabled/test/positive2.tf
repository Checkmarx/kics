# incluir versão do GKE (min_master_version) inferior a 1.10

resource "google_container_cluster" "positive2" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  min_master_version = "1.8.12-gke.2"
  addons_config {}
}