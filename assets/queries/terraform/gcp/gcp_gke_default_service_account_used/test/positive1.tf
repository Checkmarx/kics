resource "google_container_cluster" "fail_cluster" {
  name     = "insecure-cluster"
  location = "us-central1"

  node_config {
    machine_type = "e2-medium"
    # FALLO: Falta service_account
  }
}