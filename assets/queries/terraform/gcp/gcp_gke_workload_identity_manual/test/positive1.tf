resource "google_container_cluster" "fail_disabled" {
  name     = "insecure-cluster"
  location = "us-central1"
  # FALLO: Falta workload_identity_config
}