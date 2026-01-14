# incluir versão do GKE (min_master_version) superior a 1.10

resource "google_container_cluster" "negative3" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  min_master_version = "1.11.8-gke.5"
}