resource "google_container_cluster" "fail_cluster" {
  name     = "insecure-cluster"
  location = "us-central1"

  node_config {
    machine_type = "e2-medium"
    # FAIL: Missing service_account
  }
}